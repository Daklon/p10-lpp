Nodo = Struct.new(:value, :next, :prev)
  class List
    include Enumerable
    attr_reader :head, :tail
    def initialize(*values)
      @head = Nodo.new(nil, nil, nil)
      @tail = @head
      if values != nil
        values.each { |value| push_back(value) }
      end
    end
    def to_s
       ret = "{"
       temp = @head
       while (temp != @tail) do
         ret += "#{temp.value.to_s}, "
         temp = temp.next
       end
       ret += "#{temp.value.to_s}}"
       return ret
     end
     def each
       temp = @head
       while (temp != nil)
         yield temp.value
         temp = temp.next
       end
     end
    def empty
      head == tail && head.value == nil
    end
    def size
      if empty
        0
      elsif head == tail && head.value != nil
        1
      else
        i = 1
        temp = @head
        while temp != @tail
          i += 1
          temp = temp.next
        end
        return i
      end
    end
    def push_back(value)
	temp = Nodo.new(value,nil,nil)
	if empty
	    @head = temp
	    @tail = temp
	else
	    temp.prev = @tail
	    @tail.next = temp
	    @tail = temp
	end
    end
    def push_front(value)
	temp = Nodo.new(value,nil,nil)
	if empty
	    @head = temp
	    @tail = temp
	else
	    @head.prev = temp
	    temp.next = @head
	    @head = temp
	end
    end
    def pop_front()
	if size() > 1
	    temp = @head
	    @head = @head.next
	    @head.prev = nil
	    return temp.value
	elsif size() == 1
	    temp = @head
	    @head = nil
	    @tail = nil
	    return temp.value
	else
	    return nil
	end
    end
    def pop_back()
	if size() > 1
	    temp = @tail
	    @tail = @tail.prev
	    @tail.next = nil
	    return temp.value
	 elsif size() == 1
	    temp = @tail
	    @head = nil
	    @tail = nil
	    return temp.value
	 else
	    return nil
	 end
    end
    def insert(value,position)
	if position > size()-1
	    push_back(value)
	elsif position == 0
	    push_front(value)
	else 
	    i = 1
	    temp = @head.next
	    while i <= position
		if i == position
		    temp2 = temp.prev
		    data = Nodo.new(value,temp,temp2)
		    temp2.next = data
		    temp.prev = data
		else
		    temp = temp.next
		end
		i += 1
	    end
	end
    end
    def get(position)
	temp = @head
	i = 0
	while i > position || i < size()-1
	    if i == position
		return temp.value
	    else
	        temp = temp.next
	    end
	    i += 1
	end
    end
end
