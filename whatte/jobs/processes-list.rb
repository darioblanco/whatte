require 'net/http'
require 'json'


def get_url_response(path)
  base_url = URI.parse("http://localhost:5000")
  http = Net::HTTP.new(base_url.host, base_url.port)
  request = Net::HTTP::Get.new(path)
  response = http.request(request)
  JSON.parse(response.body)
end


def get_active_processes()
  begin
    processes = get_url_response("/processes")
  rescue
    return {}
  end
  process_list = Hash.new({})
  processes.each do |process_name|
    process_status = get_url_response("/status/#{process_name}")
    process_list[process_name] = {
      label: process_name,
      value: if process_status['active'] then "running" else "stopped" end
    }
  end
  return process_list
end


def get_process_data(process_name)
  begin
    process_data = get_url_response("/processes/#{process_name}")
  rescue
    return {}
  end
  data_list = Hash.new({})
  process_data.each do |data_type, data_value|
    data_list[data_type] = { label: data_type, value: data_value } unless data_type == 'env'
  end
  return data_list
end


def get_gaffer_info()
  gaffer_info = Hash.new({})
  begin
    info = get_url_response("/")
  rescue
    gaffer_info['status'] = { label: 'status', value: 'stopped'}
  else
    gaffer_info['status'] = { label: 'status', value: 'running'}
    gaffer_info['version'] = { label: 'version', value: info['version']}
  end
  return gaffer_info
end


SCHEDULER.every '30s' do
  gaffer_info = get_gaffer_info()
  send_event('gaffer-list', { items: gaffer_info.values })
end


SCHEDULER.every '2s' do
  process_list = get_active_processes()
  send_event('processes-list', { items: process_list.values })
end


SCHEDULER.every '20s' do
  yourmomma_data = get_process_data('yourmomma')
  send_event('yourmomma-list', { items: yourmomma_data.values })
  scarytornado_data = get_process_data('scarytornado')
  send_event('scarytornado-list', { items: scarytornado_data.values })
end