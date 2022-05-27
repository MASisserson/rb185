require 'pg'

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: 'todos')
    @logger = logger
  end

  # Return a list as a hash
  def find_list(list_id)
    sql = 'SELECT * FROM lists WHERE id = $1;'
    result = query(sql, list_id)
    tuple = result.first

    format_list(tuple)
  end

  # Return an array of all lists
  def all_lists
    sql = 'SELECT * FROM lists;'
    result = query(sql)

    result.map { |tuple| format_list(tuple) }
  end

  def new_list(name)
    # all_lists << { id: next_id(all_lists), name: name, todos: [] }
  end

  def rename_list(list_id, new_name)
    # list = find_list(list_id)
    # list[:name] = new_name
  end

  def delete_list(list_id)
    # delete_item(all_lists, list_id)
  end

  def add_todo(list_id, text)
    # list = find_list(list_id)
    # list[:todos] << { id: next_id(list[:todos]), name: text, completed: false }
  end

  def delete_todo(list_id, todo_id)
    # list = find_list(list_id)
    # delete_item(list[:todos], todo_id)
  end

  def set_todo_status(list_id, todo_id, status)
    # list = find_list(list_id)
    # todo = find_todo(list, todo_id)
    # todo[:completed] = status
  end

  def complete_all_todos(list_id)
    # find_list(list_id)[:todos].each { |todo| todo[:completed] = true }
  end

  private

  attr_accessor :session

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def format_list(tuple)
    { id: tuple['id'].to_i, name: tuple['name'], todos: get_todos(tuple['id']) }
  end

  def get_todos(list_id)
    sql = 'SELECT * FROM todos WHERE list_id = $1;'
    todos_result = query(sql, list_id)

    todos_result.map do |tuple|
      completed = convert_to_boolean(tuple['completed'])

      { id: tuple['id'].to_i, name: tuple['name'], completed: completed }
    end
  end

  def convert_to_boolean(string)
    case string
    when 't' then true
    when 'f' then false
    else          raise ArgumentError, 'Argument must be "true" or "false"'
    end
  end

  def delete_item(collection, item_id)
    # collection.reject! { |item| item[:id] == item_id }
  end

  def find_todo(list, todo_id)
    # list[:todos].find { |todo| todo[:id] == todo_id }
  end
end
