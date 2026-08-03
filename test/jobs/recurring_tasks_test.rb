require 'test_helper'
require 'fugit'

# Guarda config/recurring.yml contra erros de digitação: um cron inválido ou o
# nome errado de uma classe só apareceria em produção, na hora do disparo, e o
# Solid Queue apenas registraria a falha sem reexecutar.
class RecurringTasksTest < ActiveSupport::TestCase
  TASKS = YAML.load_file(Rails.root.join('config/recurring.yml'), aliases: true).fetch('production').freeze

  # Fuso obrigatório nos crons: o servidor roda em UTC e sem o fuso os horários
  # sairiam 3 horas adiantados em relação ao combinado.
  TIMEZONE = 'America/Sao_Paulo'.freeze

  test 'a seção de produção não está vazia' do
    assert_operator TASKS.size, :>, 0
  end

  test 'toda tarefa declara schedule e ou class ou command' do
    TASKS.each do |name, task|
      assert task['schedule'].present?, "#{name} está sem schedule"
      assert task['class'].present? || task['command'].present?,
             "#{name} precisa de class ou command"
    end
  end

  test 'todo schedule é parseável pelo Fugit' do
    TASKS.each do |name, task|
      schedule = task['schedule']
      assert_not_nil Fugit.parse(schedule), "#{name}: schedule inválido (#{schedule})"
    end
  end

  test 'todo schedule produz um próximo disparo no futuro' do
    TASKS.each do |name, task|
      next_time = Fugit.parse(task['schedule']).next_time.to_t

      assert_operator next_time, :>, Time.current, "#{name}: próximo disparo não está no futuro"
    end
  end

  test 'schedules em formato cron declaram o fuso de São Paulo' do
    TASKS.each do |name, task|
      schedule = task['schedule']
      next unless schedule.match?(/\A[\d*]/) # ignora os naturais, como "every hour at minute 12"

      assert schedule.end_with?(TIMEZONE), "#{name}: cron sem fuso explícito (#{schedule})"
    end
  end

  test 'toda classe referenciada existe e é um ActiveJob' do
    TASKS.each do |name, task|
      class_name = task['class']
      next if class_name.blank?

      klass = class_name.safe_constantize

      assert_not_nil klass, "#{name}: classe #{class_name} não pôde ser carregada"
      assert_operator klass, :<, ActiveJob::Base, "#{name}: #{class_name} não é um ActiveJob"
      assert klass.public_method_defined?(:perform), "#{name}: #{class_name} não define perform"
    end
  end

  test 'as classes agendadas aceitam perform sem argumentos' do
    TASKS.each do |name, task|
      class_name = task['class']
      next if class_name.blank?

      arity = class_name.constantize.instance_method(:perform).arity

      assert_equal 0, arity, "#{name}: #{class_name}#perform deveria não receber argumentos"
    end
  end
end
