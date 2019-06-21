defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index,5) * 50
      vertical  = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r,g,b | _tail]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:sha512, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  # You can do pattern matching inside of the argument list
  # means we are receiving an image as argument RHS, and then we are pattern matching it immediately

  # You might think red = image.hex[0] -- WRONG in elixir! 
  # NOTE: Take all properties of image, and then throw on top a tuple of r,g,b
  # we do not modify existing data, we always create a new record!
  # They key way to understand this is we first created a struct and pattern matched to get r,g,b extracted
  # Then we made a new struct which combines the results of first struct with the original variable
  # First hex_list is a list, put []
  #next we want r,g,b
  # we have to perfectly describe the variable on the right
  # we need a way to say there are more than 3 elements in the hexlist
  # [r,g,b | _tail] = hex_list
end

