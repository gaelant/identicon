defmodule Identicon.Image do
  # has default property of nil
  # struct is used to store all data 
  #cannot add any new properties onto struct
  # Starts to look like active record model
  # NO!!! No such thing as an instance of something that has methods. FUnctional programming. Can only hold PRIMITIVE DATA
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end