require "test_helper"

describe TasksController do
  let (:task) {
  Task.create name: "sample task", description: "this is an example for a test",
  completed: Time.now + 5.days
}

describe "index" do
  it "can get the index path" do
    
    get tasks_path
    must_respond_with :success
  end
  
  it "can get the root path" do
    
    get root_path
    must_respond_with :success
  end
end


describe "show" do
  it "can get a valid task" do
    
    get task_path(task.id)
    must_respond_with :success
  end
  
  it "will redirect for an invalid task" do
    
    get task_path(-1)
    must_respond_with :redirect
  end
end

describe "new" do
  it "can get the new task page" do
    
    get new_task_path
    
    must_respond_with :success
  end
end

describe "create" do
  it "can create a new task" do
    
    
    task_hash = {
    task: {
    name: "new task",
    description: "new task description",
    completed: nil,
  },
}


expect {
post tasks_path, params: task_hash
}.must_change "Task.count", 1

new_task = Task.find_by(name: task_hash[:task][:name])
expect(new_task.description).must_equal task_hash[:task][:description]
expect(new_task.completed).must_equal task_hash[:task][:completed]

must_respond_with :redirect
must_redirect_to task_path(new_task.id)
end
end


describe "edit" do
  it "can get the edit page for an existing task" do
    
    get edit_task_path(task.id)
    must_respond_with :success
  end
  
  it "will respond with redirect when attempting to edit a nonexistant task" do
    
    task = Task.new(id: 10)
    get edit_task_path(task.id)
    
    must_respond_with :redirect
    must_redirect_to tasks_path
  end
end


describe "update" do
  
  before do
    test_task = Task.create(name: "Best task", description: "Super fun things", completed: Time.now)
  end
  
  let (:new_task_hash) {
  {
  task: {
  name: "Errands to run",
  description: "Donate items, return library books, buy jacket",
  completed: 2019/10/10
},
}
}

it "can update an existing task" do
  id = Task.first.id
  
  patch task_path(id: id), params: new_task_hash
  edited = Task.find_by(id: id)
  expect(edited.name).must_equal "Errands to run"
  
end

it "will redirect to the index page if given an invalid id" do
  task = Task.new(id: 10)
  get edit_task_path(-1)
  
  must_redirect_to tasks_path
end
end


describe "destroy" do
  it "deletes existing task and redirects to index page" do
    test_task = Task.create(name: "Definitely a real task", description: "obviously real task", completed: Time.now)
    target_id = Task.find_by(name: "Definitely a real task").id
    
    expect {delete task_path(target_id)}.must_differ "Task.count", -1
    
    must_redirect_to root_path
  end
  
  it "redirects to index page if task is invalid" do
    
    delete task_path(-1)
    must_redirect_to root_path
  end
end


describe "toggle_complete" do
  it "when the value of completed is set to nil, sets the value to the current time and redirects to index" do
    
    target = Task.create(name: "Task Name", description: "Exciting description", completed: nil)
    patch complete_path( target.id )
    
    expect (Task.find_by(id: target.id).completed).must_be_instance_of Date
    must_redirect_to root_path
    
  end
  
  it "when the value of completed is set to a Date object, it sets the value at nil and redirects to index" do
    
    target = Task.create(name: "Task Name", description: "Exciting description", completed: Time.now)
    patch complete_path( target.id )
    
    expect(Task.find_by(id: target.id).completed).must_equal nil
    must_redirect_to root_path
  end
  
  it "redirects if the task is not valid" do
    
    patch complete_path(-1)
    must_redirect_to root_path
  end
end
end