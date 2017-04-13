class Repository
  attr_accessor :collection

  def initialize(collection)
    @collection = collection
  end

  def find_by_name(obj_name)
    obj_name.upcase!
    collection.each do |object|
      return object if object.name == obj_name
    end
  end

  def find_all_matching(partial)
    sub_set = collection.keep_if {|object|
      object.name.start_with?(partial)
    }
  end
end