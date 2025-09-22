require 'yaml'
require 'json'

# Caminho para o arquivo de cobertura gerado pelo SimpleCov
coverage_file = 'coverage/.last_run.json'
codecov_file = 'codecov.yml'

# Lê o arquivo de cobertura
unless File.exist?(coverage_file)
  puts "Arquivo de cobertura não encontrado: #{coverage_file}"
  exit 1
end

data = JSON.parse(File.read(coverage_file))

# Extrai a cobertura do formato esperado
unless data['result'] && data['result']['line']
  puts "Erro: Estrutura de cobertura inesperada no arquivo #{coverage_file}"
  exit 1
end

coverage_percentage = data['result']['line']

# Atualiza o arquivo codecov.yml
config = File.exist?(codecov_file) ? YAML.load_file(codecov_file) : {}
config['coverage'] ||= {}
config['coverage']['status'] ||= {}
config['coverage']['status']['project'] ||= {}
config['coverage']['status']['project']['default'] ||= {}
config['coverage']['status']['project']['default']['target'] = coverage_percentage

File.write(codecov_file, config.to_yaml)

puts "Arquivo #{codecov_file} atualizado com cobertura: #{coverage_percentage}%"
