require 'pg'

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname:'todos')
    @logger = logger
    # @db.exec(File.read('schema.sql'))

    #@session = session
    #@session[:lists] ||= []
  end

  def find_list(id)
    sql = "SELECT * FROM lists WHERE id = $1"
    result = query(sql, id)
    tuple = result.first
    find_todos_for_list(id)
    {id: tuple["id"], name: tuple["name"], todos: find_todos_for_list(tuple["id"])}
    #@session[:lists].find{ |list| list[:id] == id }
  end

  def new_list(list_name)
    sql = "INSERT INTO lists (name) VALUES ($1)"
    query(sql, list_name)
    # id = next_element_id(@session[:lists])
    #@session[:lists] << { id: id, name: list_name, todos: [] }
  end

  def delete_list(id)
    sql = "DELETE FROM lists WHERE id = $1"
    query(sql, id)
    #@session[:lists].reject! { |list| list[:id] == id }
  end

  def all_lists
    sql = "SELECT * FROM lists;"
    result = query(sql)

    result.map do |tuple|
      {id: tuple["id"], name: tuple["name"], todos: find_todos_for_list(tuple["id"])}
    end
    #@session[:lists]
  end

  def update_list_name(id, new_name)
    sql = "UPDATE lists SET name = $1 WHERE id = $2"
    query(sql, new_name, id)
    # list = find_list(id)
    # list[:name] = new_name
  end

  def add_todo(list_id, todo_name)
    sql = "INSERT INTO todos (name, list_id) VALUES ($1, $2)"
    query(sql, todo_name, list_id)
    # list = find_list(list_id)
    # id = next_element_id(list[:todos])
    # list[:todos] << { id: id, name: todo_name, completed: false }
  end

  def delete_todo(list_id, todo_id)
    sql = "DELETE FROM todos WHERE list_id = $1 AND id = $2"
    query(sql, list_id, todo_id)
    # list = find_list(list_id)
    # list[:todos].reject! { |todo| todo[:id] == todo_id }
  end

  def update_todo(list_id, todo_id, is_completed)
    sql = "UPDATE todos SET completed = $1 WHERE list_id = $2 AND id = $3"
    query(sql, is_completed, list_id, todo_id)
    # list = find_list(list_id)
    #odo = list[:todos].find { |t| t[:id] == todo_id }
    #odo[:completed] = is_completed
  end

  def complete_all(list_id)
    sql = "UPDATE todos SET completed = true WHERE list_id = $1"
    query(sql, list_id)
    #list = find_list(list_id)
    #list[:todos].each do |todo|
    #odo[:completed] = true
   # end
  end

  private 

  def query(sql, *params)
    @logger.info "#{sql}: #{params}"
    @db.exec_params(sql, params)
  end

  def find_todos_for_list(list_id)
    list_id = list_id.to_i
    sql = "SELECT * FROM todos WHERE list_id = $1"
    result = query(sql, list_id)
    result.map do |tuple|
      {id: tuple['id'].to_i, 
      name: tuple['name'],
      completed: tuple['completed'] == 't'}
    end
  end
end