# SketchUp Ruby API — method index

Generated from SketchUp/ruby-api-stubs. `.` = module/class method, `#` = instance method, [SketchUp X] = min version.

## Array
_Array.rb_ [SketchUp 6.0]

The SketchUp Array class adds additional methods to the standard Ruby Array

- `#cross(vector)` [SketchUp 6.0] — The {#cross} method is used to compute the cross product between two vectors.
- `#distance(point)` [SketchUp 6.0] — The {#distance} method is used to compute the distance between two points.
- `#distance_to_line(point, vector)` [SketchUp 6.0] — The {#distance_to_line} method is used to compute the distance from a {Geom::Point3d} object to a line.
- `#distance_to_plane(point, vector)` [SketchUp 6.0] — The {#distance_to_plane} method is used to compute the distance from a {Geom::Point3d} object to a plane.
- `#dot(vector)` [SketchUp 6.0] — The {#dot} method is used to compute the dot product between two vectors.
- `#normalize` [SketchUp 6.0] — The {#normalize} method is used to normalize a vector (setting its length to 1)
- `#normalize!` [SketchUp 6.0] — The {#normalize!} method is used to normalize a vector in place (setting its length to 1).
- `#offset(vector)` [SketchUp 6.0] — The {#offset} method is used to offset a point by a vector
- `#offset!(vector)` [SketchUp 6.0] — The {#offset!} method is used to offset a point by a vector
- `#on_line?(point, vector)` [SketchUp 6.0] — The {#on_line?} method is used to determine if a {Geom::Point3d} object is on a line.
- `#on_plane?(point, vector)` [SketchUp 6.0] — The {#on_plane?} method is used to determine if a {Geom::Point3d} object is on a plane (to within SketchUp's standard floating point tolerance).
- `#project_to_line(point, vector)` [SketchUp 6.0] — The {#project_to_line} method is used to retrieve the projection of a {Geom::Point3d} object onto a line.
- `#project_to_plane(point, vector)` [SketchUp 6.0] — The {#project_to_plane} method retrieves the projection of a {Geom::Point3d} onto a plane.
- `#transform(transform)` [SketchUp 6.0] — The {#transform} method is used to apply a {Geom::Transformation} or {Geom::Transformation2d} object to a {Geom::Point3d} or {Geom::Point2d} object de
- `#transform!(transform)` [SketchUp 6.0] — The {#transform!} method is used to apply a {Geom::Transformation} object to a {Geom::Point3d} object defined by an {Array} object.
- `#vector_to(point)` [SketchUp 6.0] — The {#vector_to} method is used to create an array as a vector from one point to a second point.
- `#x` [SketchUp 6.0] — The {#x} method retrieves the x coordinate.
- `#x=(x)` [SketchUp 6.0] — The {#x=} method sets the x coordinate.
- `#y` [SketchUp 6.0] — The {#y} method retrieves the y coordinate.
- `#y=(y)` [SketchUp 6.0] — The {#y=} method sets the y coordinate.
- `#z` [SketchUp 6.0] — The {#z} method retrieves the z coordinate.
- `#z=(z)` [SketchUp 6.0] — The {#z=} method sets the z coordinate.

## Geom
_Geom.rb_ [SketchUp 6.0]

The Geom module defines a number of Module methods that let you perform

- `.closest_points(line1, line2)` [SketchUp 6.0] — The {.closest_points} method is used to compute the closest points on two lines
- `.fit_plane_to_points(point1, point2, point3, ...)` [SketchUp 6.0] — The {.fit_plane_to_points} method is used to compute a plane that is a best fit to an array of points
- `.intersect_line_line(line1, line2)` [SketchUp 6.0] — The {.intersect_line_line} computes the intersection of two lines.
- `.intersect_line_plane(line, plane)` [SketchUp 6.0] — The {.intersect_line_plane} method is used to compute the intersection of a line and a plane.
- `.intersect_plane_plane(plane1, plane2)` [SketchUp 6.0] — The {.intersect_plane_plane} method is used to compute the intersection of two planes.
- `.linear_combination(weight1, point1, weight2, point2)` [SketchUp 6.0] — The {.linear_combination} method is used to compute the linear combination of points or vectors
- `.point_in_polygon_2D(point, polygon, check_border)` [SketchUp 6.0] — The {.point_in_polygon_2D} method is used to determine whether a point is inside a polygon
- `.tesselate(polygon_loop_points, *inner_loop_points)` [SketchUp 2020.0] — Tessellates a polygon, represented as a collection of 3D points

## Geom::BoundingBox
_Geom/BoundingBox.rb_ [SketchUp 6.0]

Bounding boxes are three-dimensional boxes (eight corners), aligned with the

- `#add(point_or_bb)` [SketchUp 6.0] — The add method is used to add a point, vertex, or other bounding boxes to the bounding box
- `#center` [SketchUp 6.0] — The center method is used to retrieve the Point3d object at the center of the bounding box.
- `#clear` [SketchUp 6.0] — The clear method is used to clear a bounding box
- `#contains?(point_or_bb)` [SketchUp 6.0] — This method is used to determine if a bounding box contains a specific Point3d or BoundingBox object.
- `#corner(corner_index)` [SketchUp 6.0] — The corner method is used to retrieve a point object at a specified corner of the bounding box
- `#depth` [SketchUp 6.0] — The {#depth} method is used to retrieve the Z extents of the bounding box.
- `#diagonal` [SketchUp 6.0] — The {#diagonal} method is used to get the length of the diagonal of the bounding box.
- `#empty?` [SketchUp 6.0] — The empty? method is used to determine if a bounding box is empty (such as if the bounds have not been set.) This returns the opposite of the valid? m
- `#height` [SketchUp 6.0] — The {#height} method is used to retrieve the Y extent of the bounding box.
- `#initialize` [SketchUp 6.0] — The new method is used to create a new, empty, bounding box.
- `#intersect(boundingbox)` [SketchUp 6.0] — The intersect method is used to retrieve a bounding box that is the result of intersecting one bounding box with another.
- `#max` [SketchUp 6.0] — The max method is used to retrieve the Point3d object where x, y and z are maximum in the bounding box
- `#min` [SketchUp 6.0] — The min method is used to retrieve the Point3d where x, y and z are minimum in the bounding box.
- `#valid?` [SketchUp 6.0] — The valid method is used to determine if a bounding box is valid (contains points).
- `#width` [SketchUp 6.0] — The {#width} method is used to retrieve the X extent of the bounding box.

## Geom::Bounds2d
_Geom/Bounds2d.rb_ [LayOut 2018]

The bounds2d class represents an axis aligned bounding box represented by

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Geom::Bounds2d}s are equal
- `#height` [LayOut 2018] — The {#height} method returns the height of the {Geom::Bounds2d}.
- `#initialize(other_bounds)` [LayOut 2018] — The {#initialize} method creates a new {Geom::Bounds2d}.
- `#lower_right` [LayOut 2018] — The {#lower_right} method returns the {Geom::Point2d} of the lower right corner of the {Geom::Bounds2d}.
- `#set!(other_bounds)` [LayOut 2018] — The {#set!} method is used to update the dimensions and position of a {Geom::Bounds2d} object so that it matches the specified bounds
- `#to_a` [LayOut 2018] — The {#to_a} method returns an array which contains the {Geom::Point2d}s that define the {Geom::Bounds2d}.
- `#upper_left` [LayOut 2018] — The {#upper_left} method returns the {Geom::Point2d} of the upper left corner of the {Geom::Bounds2d}.
- `#width` [LayOut 2018] — The {#width} method returns the width of the {Geom::Bounds2d}.

## Geom::LatLong
_Geom/LatLong.rb_ [SketchUp 6.0]

The LatLong class contains various methods for creating and manipulating

- `#initialize` [SketchUp 6.0] — The new method creates a LatLong object.
- `#latitude` [SketchUp 6.0] — The Latitude method retrieves the latitude coordinate from a LatLong object.
- `#longitude` [SketchUp 6.0] — The Latitude method retrieves the longitude coordinate from a LatLong object.
- `#to_a` [SketchUp 6.0] — The {#to_a} method converts a LatLong object to an array of two values.
- `#to_s` [SketchUp 6.0] — The {#to_s} method converts a LatLong object to a {String}.
- `#to_utm` [SketchUp 6.0] — The to_utm method converts a LatLong object to a UTM object.

## Geom::OrientedBounds2d
_Geom/OrientedBounds2d.rb_ [LayOut 2018]

The OrientedBounds2d class is a bounding box represented by four

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Geom::OrientedBounds2d}s are equal
- `#lower_left` [LayOut 2018] — The {#lower_left} method returns the {Geom::Point2d} of the lower left corner of the {Geom::OrientedBounds2d}.
- `#lower_right` [LayOut 2018] — The {#lower_right} method returns the {Geom::Point2d} of the lower right corner of the {Geom::OrientedBounds2d}.
- `#to_a` [LayOut 2018] — The {#to_a} method returns an array which contains the {Geom::Point2d} that define the {Geom::OrientedBounds2d}.
- `#upper_left` [LayOut 2018] — The {#upper_left} method returns the {Geom::Point2d} of the upper left corner of the {Geom::OrientedBounds2d}.
- `#upper_right` [LayOut 2018] — The {#upper_right} method returns the {Geom::Point2d} of the upper right corner of the {Geom::OrientedBounds2d}.

## Geom::Point2d
_Geom/Point2d.rb_ [LayOut 2018]

The {Geom::Point2d} class allows you to work with a point in 2D space.

- `#+(vector)` [LayOut 2018] — The {#+} operator is a simple way to add to the current x and y values of the {Geom::Point2d}, or to set the values of the {Geom::Point2d} by adding a
- `#-(array2d)` [LayOut 2018] — The {#-} operator is a simple way to subtract from the current x and y values of the {Geom::Point2d}.
- `#==(point)` [LayOut 2018] — The {#==} method compares two points for equality
- `#[](index)` [LayOut 2018] — The {#[]} method returns the value of the {Geom::Point2d} at the specified index.
- `#[]=(index, value)` [LayOut 2018] — The {#[]=} method sets the x or y value of the {Geom::Point2d} based on the specific index of the value.
- `#clone` [LayOut 2018] — The {#clone} method creates another point identical to the {Geom::Point2d} being cloned.
- `#distance(point)` [LayOut 2018] — The {#distance} method computes the distance from the {Geom::Point2d} to another {Geom::Point2d}.
- `#initialize` [LayOut 2018] — The {.new} method creates a new {Geom::Point2d}.
- `#inspect` [LayOut 2018] — The {#inspect} method formats the {Geom::Point2d} as a string.
- `#offset(vector)` [LayOut 2018] — The {#offset} method offsets the {Geom::Point2d} by a {Geom::Vector2d} and returns a new {Geom::Point2d}
- `#offset!(vector)` [LayOut 2018] — The {#offset!} method offsets the {Geom::Point2d} by a {Geom::Vector2d}
- `#set!(point)` [LayOut 2018] — The {#set!} method sets the values of the {Geom::Point2d}.
- `#to_a` [LayOut 2018] — The {#to_a} method converts the {Geom::Point2d} to an array of 2 numbers.
- `#to_s` [LayOut 2018] — The {#to_s} method returns a string representation of the {Geom::Point2d}.
- `#transform(transform)` [LayOut 2019] — The {#transform} method applies a transformation to a point, returning a new point
- `#transform!(transform)` [LayOut 2019] — The {#transform!} method applies a transformation to a point
- `#vector_to(point)` [LayOut 2018] — The {#vector_to} method returns the vector between points.
- `#x` [LayOut 2018] — The {#x} method returns the x value of the {Geom::Point2d}.
- `#x=(x)` [LayOut 2018] — The {#x=} method sets the x value of the {Geom::Point2d}.
- `#y` [LayOut 2018] — The {#y} method returns the y value of the {Geom::Point2d}.
- `#y=(y)` [LayOut 2018] — The {#y=} method sets the y value of the {Geom::Point2d}.

## Geom::Point3d
_Geom/Point3d.rb_ [SketchUp 6.0]

The Point3d class allows you to work with a point in 3D space.

- `.linear_combination(weight1, point1, weight2, point2)` [SketchUp 6.0] — The {.linear_combination} method is used to create a new point as a linear combination of two points
- `#+(vector)` [SketchUp 6.0] — The {#+} operator is a fast way to add to the current x, y and z values of a vector.
- `#-(array3d)` [SketchUp 6.0] — The '-' operator is a fast way to subtract from the current x, y and z values of a point.
- `#<(point2)` [SketchUp 6.0] — The {#<} compare method is used to compare two points to determine if the left-hand point is less than the right-hand point.
- `#==(point)` [SketchUp 6.0] — The == method is used to compare two points for equality
- `#[](index)` [SketchUp 6.0] — The [] method is used to retrieve the value of the point at the specified index.
- `#[]=(index, new_value)` [SketchUp 6.0] — The []= method is used to set the x, y, or z value of the point based on the specific index of the value.
- `#clone` [SketchUp 6.0] — The clone method is used to create another point identical to the point being cloned.
- `#distance(point2)` [SketchUp 6.0] — The distance method is used to compute the distance from a point to another point.
- `#distance_to_line(line)` [SketchUp 6.0] — The distance_to_line method is used to compute the distance from a point to a line
- `#distance_to_plane(plane)` [SketchUp 6.0] — The distance_to_plane method is used to compute the distance from the point to a plane
- `#initialize` [SketchUp 6.0] — The new method is used to create a new 3D point.
- `#inspect` [SketchUp 6.0] — The inspect method is used to format a 3D point as a string
- `#offset(vector, length = vector.length)` [SketchUp 6.0] — The offset method is used to offset a point by a vector and return a new point
- `#offset!(vector, length = vector.length)` [SketchUp 6.0] — The offset! method is used to offset a point by a vector
- `#on_line?(line)` [SketchUp 6.0] — The on_line? method is used to determine if the point is on a line
- `#on_plane?(plane)` [SketchUp 6.0] — The on_plane? method is used to determine if the point is on a plane
- `#project_to_line(line)` [SketchUp 6.0] — The project_to_line method is used to retrieve the point on a line that is closest to this point
- `#project_to_plane(plane)` [SketchUp 6.0] — The project_to_plane method is used to retrieve the point on a plane that is closest to the point
- `#set!(x, y, z)` [SketchUp 6.0] — The {#set!} method is used to set the values of the Point3d.
- `#to_a` [SketchUp 6.0] — The to_a method is used to convert the point to an array of 3 numbers
- `#to_s` [SketchUp 6.0] — The to_s method is used to retrieve a string representation of a point.
- `#transform(transform)` [SketchUp 6.0] — Apply a Transformation to a point, returning a new point
- `#transform!(transform)` [SketchUp 6.0] — Apply a Transformation to a point
- `#vector_to(point3d)` [SketchUp 6.0] — The vector_to team method retrieves the vector between points.
- `#x` [SketchUp 6.0] — The {#x} method retrieves the x value of the 3D point.
- `#x=(value)` [SketchUp 6.0] — The {#x=} method is used to set the x value of a 3D point.
- `#y` [SketchUp 6.0] — The {#y} method retrieves the y value of the 3D point.
- `#y=(value)` [SketchUp 6.0] — The {#y=} method is used to set the y value of a 3D point.
- `#z` [SketchUp 6.0] — The {#z} method retrieves the z value of the 3D point.
- `#z=(value)` [SketchUp 6.0] — The {#z=} method is used to set the z value of a 3D point.

## Geom::PolygonMesh
_Geom/PolygonMesh.rb_ [SketchUp 6.0]

The {#Geom::PolygonMesh} class contains methods to create polygon mesh

Constants: AUTO_SOFTEN, HIDE_BASED_ON_INDEX, NO_SMOOTH_OR_HIDE, SMOOTH_SOFT_EDGES, SOFTEN_BASED_ON_INDEX, MESH_NORMALS, MESH_POINTS, MESH_UVQ_BACK, MESH_UVQ_FRONT

- `#add_point(point)` [SketchUp 6.0] — The {#add_point} method is used to add a point to the mesh
- `#add_polygon(index, index, index, ...)` [SketchUp 6.0] — The {#add_polygon} method is used for adding a polygon to a {Geom::PolygonMesh}
- `#count_points` [SketchUp 6.0] — The {#count_points} method is used to count the number of points in a mesh.
- `#count_polygons` [SketchUp 6.0] — The {#count_polygons} count the number of polygons in the mesh.
- `#initialize` [SketchUp 6.0] — Create a new empty polygon mesh
- `#normal_at(index)` [SketchUp 6.0] — The {#normal_at} method is used to determine the vertex normal at a particular index in the mesh
- `#point_at(index)` [SketchUp 6.0] — The {#point_at} method is used to retrieve the point at a specific index in the mesh.
- `#point_index(point)` [SketchUp 6.0] — The {#point_index} method is used to retrieve the index of a point in the mesh.
- `#points` [SketchUp 6.0] — The {#points} method is used to retrieve an array of points (vertices) in the mesh
- `#polygon_at(index)` [SketchUp 6.0] — The {#polygon_at} method is used to retrieve an array of vertex index values for a polygon at a specific index.
- `#polygon_points_at(index)` [SketchUp 6.0] — The {#polygon_points_at} method is used to retrieve the points for a polygon that is at a specific index in the mesh.
- `#polygons` [SketchUp 6.0] — The {#polygons} method is used to retrieve an array of all polygons in the mesh
- `#set_point(index, point)` [SketchUp 6.0] — The {#set_point} method is used to set the point at a specific index in the mesh.
- `#set_uv(index, point, front)` [SketchUp 2014] — The {#set_uv} method is used to define UV mapping coordinates to points in the mesh
- `#transform!(transformation)` [SketchUp 6.0] — The {#transform!} method is used to apply a transformation to a mesh.
- `#uv_at(index, front)` [SketchUp 6.0] — The {#uv_at} method is used to access a uv (texture coordinates) at a specific index
- `#uvs(front)` [SketchUp 6.0] — The {#uvs} method is used to retrieve an array of uv coordinates in the mesh.

## Geom::Transformation
_Geom/Transformation.rb_ [SketchUp 6.0]

Transformations are a standard construct in the 3D world for representing

- `.axes(origin, xaxis, yaxis, zaxis)` [SketchUp 6.0] — The {.axes} method creates a transformation that goes from world coordinates to an arbitrary coordinate system defined by an origin and three axis vec
- `.interpolate(transformation1, transformation2, weight)` [SketchUp 6.0] — The {.interpolate} method is used to create a new transformation that is the result of interpolating between two other transformations
- `.rotation(point, vector, angle)` [SketchUp 6.0] — The {.rotation} method is used to create a transformation that does rotation about an axis
- `.scaling(scale)` [SketchUp 6.0] — The {.scaling} method is used to create a transformation that does scaling.
- `.translation(vector)` [SketchUp 6.0] — The {.translation} method is used to create a transformation that does translation.
- `#*(point)` [SketchUp 6.0] — The {#*} method is used to do matrix multiplication using the transform.
- `#clone` [SketchUp 6.0] — The {#clone} method is used to create a copy of a transformation.
- `#identity?` [SketchUp 6.0] — The {#identity?} method is used to determine if a transformation is the {IDENTITY} transform.
- `#initialize` [SketchUp 6.0] — You can use this method or one of the more specific methods for creating specific kinds of Transformations.
- `#inverse` [SketchUp 6.0] — The {#inverse} method is used to retrieve the inverse of a transformation.
- `#invert!` [SketchUp 6.0] — The {#invert!} method sets the transformation to its inverse.
- `#origin` [SketchUp 6.0] — The {#origin} method retrieves the origin of a rigid transformation.
- `#set!(transformation)` [SketchUp 6.0] — The {#set!} method is used to set this transformation to match another one
- `#to_a` [SketchUp 6.0] — The {#to_a} method retrieves a 16 element array which contains the values that define the transformation.
- `#xaxis` [SketchUp 6.0] — The {#xaxis} method retrieves the x axis of a rigid transformation.
- `#yaxis` [SketchUp 6.0] — The {#yaxis} method retrieves the y axis of a rigid transformation.
- `#zaxis` [SketchUp 6.0] — The {#zaxis} method retrieves the z axis of a rigid transformation.

## Geom::Transformation2d
_Geom/Transformation2d.rb_ [LayOut 2018]



- `.rotation(point, angle)` [LayOut 2019] — The {.rotation} method is used to create a transformation that does rotation about a point.
- `.scaling(scale)` [LayOut 2019] — The {.scaling} method is used to create a transformation that does scaling.
- `.translation(vector)` [LayOut 2019] — The {.translation} method is used to create a transformation that does translation.
- `#*(point)` [LayOut 2019] — The {#*} method is used to do matrix multiplication using the transform.
- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Geom::Transformation2d}s are equal
- `#clone` [LayOut 2018] — The {#clone} method creates a copy of the {Geom::Transformation2d}.
- `#identity?` [LayOut 2018] — The {#identity?} method determines if the {Geom::Transformation2d} is the {IDENTITY_2D} transform.
- `#initialize` [LayOut 2018] — The {#initialize} method creates a new {Geom::Transformation2d}
- `#inverse` [LayOut 2019] — The {#inverse} method is used to retrieve the inverse of a transformation.
- `#invert!` [LayOut 2019] — The {#invert!} method sets the transformation to its inverse.
- `#set!(transformation)` [LayOut 2018] — The {#set!} method sets the {Geom::Transformation2d} to match another one
- `#to_a` [LayOut 2018] — The {#to_a} method returns a 6 element array which contains the values that define the Transformation2d.

## Geom::UTM
_Geom/UTM.rb_ [SketchUp 6.0]

The UTM class lets you work with UTM map coordinates.

- `#initialize(zone_number, zone_letter, x, y)` [SketchUp 6.0] — The {#initialize} method is used to create a new UTM coordinate
- `#to_a` [SketchUp 6.0] — The {#to_a} method returns a UTM coordinate as a 4 element array
- `#to_latlong` [SketchUp 6.0] — The {#to_latlong} method is used to convert UTM coordinates to latitude and longitude
- `#to_s` [SketchUp 6.0] — The {#to_s} method is used to retrieve a string representation of a UTM.
- `#x` [SketchUp 6.0] — The {#x} method returns the UTM x coordinate.
- `#y` [SketchUp 6.0] — The {#y} method returns the UTM y coordinate.
- `#zone_letter` [SketchUp 6.0] — The {#zone_letter} method returns the UTM zone letter.
- `#zone_number` [SketchUp 6.0] — The {#zone_number} method returns the UTM zone number.

## Geom::Vector2d
_Geom/Vector2d.rb_ [LayOut 2018]

The {Geom::Vector2d} class represents vectors in a 2 dimensional space.

- `#%(vector)` [SketchUp 6.0] — The {#%} method is used to compute the dot product between two vectors
- `#*(vector)` [LayOut 2018] — The {#*} method returns the cross product between two {Geom::Vector2d}
- `#+(vector)` [LayOut 2018] — The {#+} method adds a {Geom::Vector2d} to this one.
- `#-(vector)` [LayOut 2018] — The {#-} method subtracts a {Geom::Vector2d} from this one.
- `#==(vector)` [LayOut 2018] — The {#==} method returns whether two {Geom::Vector2d} are equal within tolerance.
- `#[](index)` [LayOut 2018] — The {#[]} method returns the value of the {Geom::Vector2d} at the specified index.
- `#[]=(index, value)` [LayOut 2018] — The {#[]=} method sets the x or y value of the {Geom::Vector2d} based on the specific index of the value.
- `#angle_between(vector)` [LayOut 2018] — The {#angle_between} method computes the angle in radians between the {Geom::Vector2d} and another {Geom::Vector2d}.
- `#clone` [LayOut 2018] — The {#clone} method makes a copy of the {Geom::Vector2d}
- `#cross(vector)` [LayOut 2018] — The {#cross} method returns the cross product between two {Geom::Vector2d}s
- `#dot(vector)` [SketchUp 6.0] — The {#dot} method is used to compute the dot product between two vectors.
- `#initialize` [LayOut 2018] — The {.new} method creates a new {Geom::Vector2d}.
- `#inspect` [LayOut 2018] — The {#inspect} method formats the {Geom::Vector2d} as a string.
- `#length` [LayOut 2018] — The {#length} method returns the length of the {Geom::Vector2d}.
- `#length=(length)` [LayOut 2018] — The {#length=} method sets the length of the {Geom::Vector2d}
- `#normalize` [LayOut 2018] — The {#normalize} method returns a {Geom::Vector2d} that is a unit vector of the {Geom::Vector2d}.
- `#normalize!` [LayOut 2018] — The {#normalize!} method converts a {Geom::Vector2d} vector into a unit vector
- `#parallel?(vector)` [LayOut 2018] — The {#parallel?} method determines if two {Geom::Vector2d}s are parallel within a tolerance
- `#perpendicular?(vector)` [LayOut 2018] — The {#perpendicular?} method determines if two {Geom::Vector2d}s are perpendicular within a tolerance
- `#reverse` [LayOut 2018] — The {#reverse} method returns a new {Geom::Vector2d} that is the reverse of the {Geom::Vector2d}, leaving the original unchanged.
- `#reverse!` [LayOut 2018] — The {#reverse!} method reverses the {Geom::Vector2d} in place.
- `#same_direction?(vector)` [LayOut 2018] — The {#same_direction?} method determines if the {Geom::Vector2d} is parallel to and in the same direction as another {Geom::Vector2d} within tolerance
- `#set!(vector)` [LayOut 2018] — The {#set!} method sets the values of the {Geom::Vector2d}.
- `#to_a` [LayOut 2018] — The {#to_a} method retrieves the coordinates of the {Geom::Vector2d} in an Array.
- `#to_s` [LayOut 2018] — The {#to_s} method returns a string representation of the {Geom::Vector2d}.
- `#transform(transform)` [LayOut 2019] — The {#transform} method applies a transformation to a vector, returning a new vector
- `#transform!(transform)` [LayOut 2019] — The {#transform!} method applies a transformation to a vector
- `#unit_vector?` [LayOut 2018] — The {#unit_vector?} method returns whether the {Geom::Vector2d} is a unit vector
- `#valid?` [LayOut 2018] — The {#valid?} method verifies if a {Geom::Vector2d} is valid
- `#x` [LayOut 2018] — The {#x} method retrieves the x value of the {Geom::Vector2d}.
- `#x=(x)` [LayOut 2018] — The {#x=} method sets the x coordinate of the {Geom::Vector2d}.
- `#y` [LayOut 2018] — The {#y} method retrieves the y value of the {Geom::Vector2d}.
- `#y=(y)` [LayOut 2018] — The {#y=} method sets the y coordinate of the {Geom::Vector2d}.

## Geom::Vector3d
_Geom/Vector3d.rb_ [SketchUp 6.0]

The Vector3d class is used to represent vectors in a 3 dimensional space.

- `.linear_combination(weight1, vector1, weight2, vector2)` [SketchUp 6.0] — The {.linear_combination} method is used to create a new vector as a linear combination of other vectors
- `#%(vector3d)` [SketchUp 6.0] — The {#%} method is used to compute the dot product between two vectors
- `#*(vector3d)` [SketchUp 6.0] — The {#*} method is used to compute the cross product between two vectors
- `#+(vector3d)` [SketchUp 6.0] — The {#+} method is used to add a vector to this one.
- `#-(vector3d)` [SketchUp 6.0] — The {#-} method is used to subtract a vector from this one.
- `#<(vector3d)` [SketchUp 6.0] — The {#<} compare method is used to compare two vectors to determine if the left-hand vector is less than the right-hand vector.
- `#==(vector3d)` [SketchUp 6.0] — The {#==} method is used to determine if two vectors are equal to within tolerance.
- `#[](index)` [SketchUp 6.0] — The {[]} method is used to access the coordinates of a vector as if it was an Array
- `#[]=(index, value)` [SketchUp 6.0] — The {[]=} method is used to set the coordinates of a vector as if it was an Array
- `#angle_between(vector3d)` [SketchUp 6.0] — The {#angle_between} method is used to compute the angle (in radians) between this vector and another vector.
- `#axes` [SketchUp 6.0] — The {#axes} method is used to compute an arbitrary set of axes with the given vector as the z-axis direction
- `#clone` [SketchUp 6.0] — The {#clone} method is used to make a copy of a vector.
- `#cross(vector3d)` [SketchUp 6.0] — The {#cross} method is used to compute the cross product between two vectors
- `#dot(vector3d)` [SketchUp 6.0] — The {#dot} method is used to compute the dot product between two vectors.
- `#initialize` [SketchUp 6.0] — The new method is used to create a new vector.
- `#inspect` [SketchUp 6.0] — The {#inspect} method is used to inspect the contents of a vector as a friendly string.
- `#length` [SketchUp 6.0] — The {#length} method is used to retrieve the length of the vector.
- `#length=(length)` [SketchUp 6.0] — The {#length=} method is used to set the length of the vector
- `#normalize` [SketchUp 6.0] — The {#normalize} method is used to return a vector that is a unit vector of another.
- `#normalize!` [SketchUp 6.0] — The {#normalize!} method is used to convert a vector into a unit vector, in place
- `#parallel?(vector3d)` [SketchUp 6.0] — The {#parallel?} method determines if two {Geom::Vector3d}s are parallel within a tolerance
- `#perpendicular?(vector3d)` [SketchUp 6.0] — The {#perpendicular?} method determines if two Geom::Vector3ds are perpendicular within a tolerance
- `#reverse` [SketchUp 6.0] — The {#reverse} method is used to return a new vector that is the reverse of this vector, while leaving the original unchanged.
- `#reverse!` [SketchUp 6.0] — The {#reverse!} method is used to reverse the vector in place.
- `#samedirection?(vector3d)` [SketchUp 6.0] — The {#samedirection?} method is used to determine if this vector is parallel to and in the same direction as another vector to within tolerance.
- `#set!(vector)` [SketchUp 6.0] — The {#set!} method is used to set the coordinates of the vector.
- `#to_a` [SketchUp 6.0] — The {#to_a} method retrieves the coordinates of the vector in an Array[x, y, z].
- `#to_s` [SketchUp 6.0] — The {#to_s} method is used to format the vector as a String.
- `#transform(transform)` [SketchUp 6.0] — The {#transform} method applies a Transformation to a vector, returning a new vector
- `#transform!(transform)` [SketchUp 6.0] — The {#transform!} method applies a Transformation to a vector
- `#unitvector?` [SketchUp 6.0] — The {#unitvector?} method is used to see if the vector is a unit vector
- `#valid?` [SketchUp 6.0] — The {#valid?} method is used to verify if a vector is valid
- `#x` [SketchUp 6.0] — The {#x} method is used to retrieve the x coordinate of the vector.
- `#x=(x)` [SketchUp 6.0] — The {#x=} method is used to set the x coordinate of the vector.
- `#y` [SketchUp 6.0] — The {#y} method is used to retrieve the y coordinate of the vector.
- `#y=(y)` [SketchUp 6.0] — Set the {#y=} coordinate of the vector.
- `#z` [SketchUp 6.0] — Get the {#z} coordinate of the vector.
- `#z=(z)` [SketchUp 6.0] — Set the {#z=} coordinate of the vector.

## LanguageHandler
_LanguageHandler.rb_ [SketchUp 2014]

The LanguageHandler class contains methods used to help make SketchUp

- `#[](key)` [SketchUp 2014] — Looks up and returns the localized version of a given string, based on the language SketchUp is currently running in, and the available translations i
- `#initialize(filename)` [SketchUp 2014] — The new method is used to create a new LanguageHandler object.
- `#resource_path` [SketchUp 2014] — Returns a string containing the path to the given filename if it can be found in the Resources folder.
- `#strings` [SketchUp 2014] — Returns a Hash object containing the localization dictionary.

## Layout
_Layout.rb_ [LayOut 2018]

The LayOut module is the root of the LayOut Ruby API. Many of the classes in


## Layout::AngularDimension < Layout::Entity
_Layout/AngularDimension.rb_ [LayOut 2018]

References an angular dimension entity. An {Layout::AngularDimension} is

Constants: LEADER_LINE_TYPE_BEZIER, LEADER_LINE_TYPE_HIDDEN, LEADER_LINE_TYPE_SINGLE_SEGMENT, LEADER_LINE_TYPE_TWO_SEGMENT

- `#angle` [LayOut 2018] — The {#angle} method returns the {Layout::AngularDimension}'s angle
- `#arc_center_point` [LayOut 2018] — The {#arc_center_point} method returns the paper space location for the dimension arc center point
- `#custom_text=(uses_custom_text)` [LayOut 2018] — The {#custom_text=} sets whether or not the {Layout::AngularDimension} uses custom text
- `#custom_text?` [LayOut 2018] — The {#custom_text?} method returns whether the {Layout::AngularDimension} uses custom text
- `#end_connection_point` [LayOut 2018] — The {#end_connection_point} method returns the paper space location for the second connection
- `#end_connection_point=(end_point)` [LayOut 2018] — The {#end_connection_point=} method sets the paper space location for the second connection
- `#end_extent_point` [LayOut 2018] — The {#end_extent_point} method returns the paper space location for the end of the dimension line
- `#end_extent_point=(end_extent)` [LayOut 2018] — The {#end_extent_point=} method sets the paper space location for the end of the dimension line
- `#end_offset_length=(offset_length)` [LayOut 2018] — The {#end_offset_length=} method sets the length of the offset from the second connection point to the start of the second extension line
- `#end_offset_point` [LayOut 2018] — The {#end_offset_point} method returns the paper space location for the end of the first extension line
- `#entities` [LayOut 2018] — The {#entities} method returns the {Layout::Entities} that represent the {Layout::AngularDimension} in its exploded form
- `#initialize(start_point, end_point, start_extent_point, end_extent_point, inner_angle)` [LayOut 2018] — The {#initialize} method creates a new disconnected {Layout::AngularDimension}
- `#leader_line_type` [LayOut 2018] — The {#leader_line_type} method returns the type of leader line the {Layout::AngularDimension} is using
- `#leader_line_type=(type)` [LayOut 2018] — The {#leader_line_type=} method sets the type of leader line the {Layout::AngularDimension} is using
- `#radius` [LayOut 2018] — The {#radius} method returns the {Layout::AngularDimension}'s radius
- `#radius=(radius)` [LayOut 2018] — The {#radius=} method sets the the {Layout::AngularDimension}'s radius
- `#start_connection_point` [LayOut 2018] — The {#start_connection_point} method returns the paper space location for the first connection
- `#start_connection_point=(start_point)` [LayOut 2018] — The {#start_connection_point=} method sets the paper space location for the first connection
- `#start_extent_point` [LayOut 2018] — The {#start_extent_point} method returns the paper space location for the start of the dimension line
- `#start_extent_point=(start_extent)` [LayOut 2018] — The {#start_extent_point=} method sets the paper space location for the start of the dimension line
- `#start_offset_length=(offset_length)` [LayOut 2018] — The {#start_offset_length=} method sets the length of the offset from the first connection point to the start of the first extension line
- `#start_offset_point` [LayOut 2018] — The {#start_offset_point} method returns the paper space location for the start of the first extension line
- `#text` [LayOut 2018] — The {#text} method returns a copy of the {Layout::AngularDimension}'s {Layout::FormattedText}
- `#text=(formatted_text)` [LayOut 2018] — The {#text=} method sets the {Layout::AngularDimension}'s {Layout::FormattedText}

## Layout::AutoTextDefinition
_Layout/AutoTextDefinition.rb_ [LayOut 2018]

References an auto-text definition. Some auto-text definitions are mandatory.

Constants: NUMBER_STYLE_ARABIC, NUMBER_STYLE_ARABIC_PADDED, NUMBER_STYLE_LC_ALPHA, NUMBER_STYLE_LC_ROMAN, NUMBER_STYLE_UC_ALPHA, NUMBER_STYLE_UC_ROMAN, SEQUENCE_TYPE_PER_DOCUMENT, SEQUENCE_TYPE_PER_PAGE, TYPE_CUSTOM_TEXT, TYPE_DATE_CREATED, TYPE_DATE_CURRENT, TYPE_DATE_MODIFIED, TYPE_DATE_PUBLISHED, TYPE_FILE, TYPE_MODEL_CLASSIFIER_ATTRIBUTE, TYPE_MODEL_COMPONENT_DEFINITION_ATTRIBUTE, TYPE_MODEL_COMPONENT_DEFINITION_NAME, TYPE_MODEL_COMPONENT_DESCRIPTION, TYPE_MODEL_COMPONENT_INSTANCE_ATTRIBUTE, TYPE_MODEL_COMPONENT_INSTANCE_NAME, TYPE_MODEL_COORDINATES, TYPE_MODEL_DYNAMIC_COMPONENT_ATTRIBUTE, TYPE_MODEL_EDGE_LENGTH, TYPE_MODEL_FACE_AREA, TYPE_MODEL_GROUP_NAME, TYPE_MODEL_RATIO, TYPE_MODEL_SCALE, TYPE_MODEL_SCENE_DESCRIPTION, TYPE_MODEL_SCENE_NAME, TYPE_MODEL_SECTION_NAME, TYPE_MODEL_SECTION_SYMBOL, TYPE_MODEL_VOLUME, TYPE_PAGE_COUNT, TYPE_PAGE_NAME, TYPE_PAGE_NUMBER, TYPE_SEQUENCE

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Layout::AutoTextDefinition}s are equal
- `#custom_text` [LayOut 2018] — The {#custom_text} method returns the custom text of the +Layout::AutoTextDefinition::TYPE_CUSTOM_TEXT+ {Layout::AutoTextDefinition}.
- `#custom_text=(custom_text)` [LayOut 2018] — The {#custom_text} method sets the custom text of the +Layout::AutoTextDefinition::TYPE_CUSTOM_TEXT+ {Layout::AutoTextDefinition}.
- `#date_format` [LayOut 2018] — The {#date_format} method returns the date format of a +Layout::AutoTextDefinition::TYPE_DATE_*+ {Layout::AutoTextDefinition}.
- `#date_format=(date_format)` [LayOut 2018] — The {#date_format} method sets the date format of a +Layout::AutoTextDefinition::TYPE_DATE_*+ {Layout::AutoTextDefinition}.
- `#display_file_extension=(display_file_extension)` [LayOut 2018] — The {#display_file_extension=} method sets whether the +Layout::AutoTextDefinition::TYPE_FILE+ {Layout::AutoTextDefinition} displays the file extensio
- `#display_file_extension?` [LayOut 2018] — The {#display_file_extension?} method returns whether the +Layout::AutoTextDefinition::TYPE_FILE+ {Layout::AutoTextDefinition} displays the file exten
- `#display_full_path=(display_full_path)` [LayOut 2018] — The {#display_full_path=} method sets whether the +Layout::AutoTextDefinition::TYPE_FILE+ {Layout::AutoTextDefinition} displays the full path.
- `#display_full_path?` [LayOut 2018] — The {#display_full_path?} method returns whether the +Layout::AutoTextDefinition::TYPE_FILE+ {Layout::AutoTextDefinition} displays the full path.
- `#end_page` [LayOut 2022.0] — The {#end_page} method returns the end page for the +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+ {Layout::AutoTextDefinition}.
- `#end_page=(page)` [LayOut 2022.0] — The {#end_page=} method sets the end page for the +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+ {Layout::AutoTextDefinition}.
- `#increment` [LayOut 2022.0] — The {#increment} method returns the increment value for +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition}s.
- `#increment=(increment)` [LayOut 2022.0] — The {#increment=} method sets the increment value for +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition}s.
- `#mandatory?` [LayOut 2018] — The {#mandatory?} method returns whether the {Layout::AutoTextDefinition} is mandatory or not
- `#name` [LayOut 2018] — The {#name} method returns the name of the {Layout::AutoTextDefinition}.
- `#name=(name)` [LayOut 2018] — The {#name=} method sets the name of the {Layout::AutoTextDefinition}.
- `#number_style` [LayOut 2022.0] — The {#number_style} method returns the numbering style for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+, +Layout::AutoTextDefinition::TYPE_PAGE_COUN
- `#number_style=(number_style)` [LayOut 2022.0] — The {#number_style=} method sets the numbering style for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+, +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+
- `#page_number_style` [LayOut 2018] **DEPRECATED** — The {#page_number_style} method returns the numbering style for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+ {Layout::AutoTextDefinition}s
- `#page_number_style=(number_style)` [LayOut 2018] **DEPRECATED** — The {#page_number_style=} method sets the numbering style for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+ {Layout::AutoTextDefinition}s
- `#renumber` [LayOut 2022.0] — The {#renumber} method iterates through all uses of the +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition} and eliminates gaps a
- `#sequence_format` [LayOut 2022.0] — The {#sequence_format} method returns the sequence format of a +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition}.
- `#sequence_format=(sequence_format)` [LayOut 2022.0] — The {#sequence_format=} method sets the sequence format of a +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition}.
- `#sequence_type` [LayOut 2023.0] — The {#sequence_type} method returns how the +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition} operates over multiple pages in a
- `#sequence_type=(sequence_type)` [LayOut 2023.0] — The {#sequence_type=} method sets how the +Layout::AutoTextDefinition::TYPE_SEQUENCE+ {Layout::AutoTextDefinition} operates over multiple pages in a d
- `#start_index` [LayOut 2018] — The {#start_index} method returns the start index for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+, +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+, a
- `#start_index=(index)` [LayOut 2018] — The {#start_index=} method sets the start index for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+, +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+, and
- `#start_page` [LayOut 2022.0] — The {#start_page} method returns the start page for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+ and +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+ {
- `#start_page=(page)` [LayOut 2022.0] — The {#start_page=} method sets the start page for +Layout::AutoTextDefinition::TYPE_PAGE_NUMBER+ and +Layout::AutoTextDefinition::TYPE_PAGE_COUNT+ {La
- `#tag` [LayOut 2018] — The {#tag} method returns the tag string of the {Layout::AutoTextDefinition}.
- `#type` [LayOut 2018] — The {#type} method returns the type of the {Layout::AutoTextDefinition}

## Layout::AutoTextDefinitions
_Layout/AutoTextDefinitions.rb_ [LayOut 2018]

The AutoTextDefinitions class is a container class for all

- `#[](index)` [LayOut 2018] — The {#[]} method returns a value from the array of {Layout::AutoTextDefinition}s.
- `#add(name, type)` [LayOut 2018] — The {#add} method adds an {Layout::AutoTextDefinition} to the {Layout::Document}
- `#each` [LayOut 2018] — The {#each} method iterates through all of the {Layout::AutoTextDefinition}s.
- `#index(auto_text)` [LayOut 2018] — The {#index} method returns the index of the {Layout::AutoTextDefinition}, or +nil+ if it doesn't exist in the {Layout::Document}.
- `#length` [LayOut 2018] — The {#length} method returns the number of {Layout::AutoTextDefinition}s.
- `#remove(definition, convert_tags_to_text = true)` [LayOut 2018] — The {#remove} method removes an {Layout::AutoTextDefinition} from the {Layout::Document}

## Layout::ConnectionPoint
_Layout/ConnectionPoint.rb_ [LayOut 2018]

This is the interface to a LayOut Connection Point. A

- `#initialize(entity, point, aperture = 0.0001)` [LayOut 2018] — The {#initialize} method creates a new {Layout::ConnectionPoint}.

## Layout::Dictionary
_Layout/Dictionary.rb_ [LayOut 2026.0]

This is the interface to a LayOut dictionary. A {Layout::Dictionary} wraps key/value pairs.

- `#[](key)` [LayOut 2026.0] — The {#[]} method retrieves the value for a given key.
- `#[]=(key, value)` [LayOut 2026.0] — The {#[]=} method sets a value for a given key
- `#delete_key(key)` [LayOut 2026.0] — The {#delete_key} method deletes a key/value pair from the dictionary.
- `#each` [LayOut 2026.0] — The {#each_pair} method is an alias for {#each}.
- `#each_key` [LayOut 2026.0] — The {#each_key} method iterates through all of the dictionary keys.
- `#each_pair` [LayOut 2026.0] — The {#each_pair} method is an alias for {#each}.
- `#empty?` [LayOut 2026.0] — The {#empty?} method checks if the dictionary is empty.
- `#initialize` [LayOut 2026.0] — The {#initialize} method creates a new {Layout::Dictionary}.
- `#keys` [LayOut 2026.0] — The {#keys} method retrieves an array with all of the dictionary keys.
- `#length` [LayOut 2026.0] — The {#length} method retrieves the size (number of elements) of a dictionary.
- `#size` [LayOut 2026.0] — The {#length} method retrieves the size (number of elements) of a dictionary.
- `#values` [LayOut 2026.0] — The {#values} method retrieves an array with all of the dictionary values.

## Layout::Document
_Layout/Document.rb_ [LayOut 2018]

This is the interface to a LayOut document. A {Layout::Document} is the 2D

Constants: DECIMAL_CENTIMETERS, DECIMAL_FEET, DECIMAL_INCHES, DECIMAL_METERS, DECIMAL_MILLIMETERS, DECIMAL_POINTS, FRACTIONAL_INCHES, VERSION_1, VERSION_2, VERSION_2013, VERSION_2014, VERSION_2015, VERSION_2016, VERSION_2017, VERSION_2018, VERSION_2019, VERSION_2020, VERSION_2021, VERSION_2022, VERSION_2023, VERSION_3, VERSION_CURRENT

- `.open(path)` [LayOut 2018] — The {.open} method creates a new {Layout::Document} by loading an existing .layout file.
- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Layout::Document}s are equal
- `#add_entity(entity, layer, page)` [LayOut 2018] — The {#add_entity} method adds an {Layout::Entity} to the {Layout::Document} and places it on the given {Layout::Layer} and {Layout::Page}
- `#attribute_dictionary(name)` [LayOut 2026.0] — The {#attribute_dictionary} method returns a copy of the document's attribute dictionary with the given name
- `#auto_text_definitions` [LayOut 2018] — The {#auto_text_definitions} method returns an array of {Layout::AutoTextDefinition}'s in the {Layout::Document}.
- `#delete_attribute(dictionary_name)` [LayOut 2026.0] — The {#delete_attribute} method is used to delete an attribute from a document.
- `#export(file_path, options = nil)` [LayOut 2020.1] — The {#export} method exports the {Layout::Document} to a given file format
- `#get_attribute(name, key, default_value = nil)` [LayOut 2026.0] — The {#get_attribute} method is used to retrieve the value of an attribute in the document's attribute dictionary
- `#grid` [LayOut 2018] — The {#grid} method returns the {Layout::Grid} for a {Layout::Document}.
- `#grid_snap_enabled=(enabled)` [LayOut 2018] — The {#grid_snap_enabled=} method sets whether or not grid snap is enabled in the {Layout::Document}.
- `#grid_snap_enabled?` [LayOut 2018] — The {#grid_snap_enabled?} method returns whether or not grid snap is enabled in the {Layout::Document}.
- `#initialize` [LayOut 2018] — The {#initialize} method creates a new {Layout::Document}
- `#layers` [LayOut 2018] — The {#layers} method returns the {Layout::Layers} of the {Layout::Document}.
- `#object_snap_enabled=(enabled)` [LayOut 2018] — The {#object_snap_enabled=} method enables or disables inference in the {Layout::Document}.
- `#object_snap_enabled?` [LayOut 2018] — The {#object_snap_enabled?} method returns whether or not inference is enabled in the {Layout::Document}.
- `#page_info` [LayOut 2018] — The {#page_info} method returns a reference to the {Layout::PageInfo} settings of the {Layout::Document}.
- `#pages` [LayOut 2018] — The {#pages} method returns the {Layout::Pages} of the {Layout::Document}.
- `#path` [LayOut 2018] — The {#path} method returns the full path of the {Layout::Document} file
- `#precision` [LayOut 2018] — The {#precision} method returns the precision for the {Layout::Document}.
- `#precision=(precision)` [LayOut 2018] — The {#precision=} method sets the precision for the {Layout::Document}.
- `#remove_entity(entity)` [LayOut 2018] — The {#remove_entity} method removes an {Layout::Entity} from the {Layout::Document}
- `#render_mode_override` [LayOut 2023.1] — The {#render_mode_override} method returns the override setting for output render modes of {Layout::SketchUpModel}s in the {Layout::Document}.
- `#render_mode_override=(render_mode)` [LayOut 2023.1] — The {#render_mode_override=} method sets the override setting for output render modes of {Layout::SketchUpModel}s in the {Layout::Document}
- `#save` [LayOut 2018] — The {#save} method saves the {Layout::Document} to a file at the given path
- `#set_attribute(name, key, value)` [LayOut 2026.0] — The {#set_attribute} method adds an attribute to the document's attribute dictionary.
- `#shared_entities` [LayOut 2018] — The {#shared_entities} method returns the {Layout::Entities} that exist on shared {Layout::Layer}s in the {Layout::Document}.
- `#time_created` [LayOut 2018] — The {#time_created} method returns the time when the {Layout::Document} was created.
- `#time_modified` [LayOut 2018] — The {#time_modified} method returns the last time the {Layout::Document} was modified.
- `#time_published` [LayOut 2018] — The {#time_published} method returns the time when the {Layout::Document} was published.
- `#units` [LayOut 2018] — The {#units} method returns the units for the {Layout::Document}.
- `#units=(units_format)` [LayOut 2018] — The {#units=} method sets the units for the {Layout::Document}.

## Layout::Ellipse < Layout::Entity
_Layout/Ellipse.rb_ [LayOut 2018]

A simple elliptical shape entity.

- `#initialize(bounds)` [LayOut 2018] — The {#initialize} method creates a new {Layout::Ellipse}.

## Layout::Entities
_Layout/Entities.rb_ [LayOut 2018]

The Entities class is a container class for {Layout::Entity}s. A

- `#[](index)` [LayOut 2018] — The {#[]} method returns the {Layout::Entity} at the given index
- `#each(flags = {})` [LayOut 2018] — The {#each} method iterates through all of the {Layout::Entity}s
- `#length` [LayOut 2018] — The {#length} method returns the number of {Layout::Entity}s.
- `#reverse_each` [LayOut 2018] — The {#reverse_each} method iterates through all of the {Layout::Entity}s in reverse order

## Layout::Entity
_Layout/Entity.rb_ [LayOut 2018]

An entity is an object shown on a page of a LayOut document.

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Layout::Entity}s are equal
- `#attribute_dictionary(name)` [LayOut 2026.0] — The {#attribute_dictionary} method returns a copy of the entity's attribute dictionary with the given name
- `#bounds` [LayOut 2018] — The {#bounds} method returns the 2D rectangular bounds of the {Layout::Entity}.
- `#delete_attribute(dictionary_name)` [LayOut 2026.0] — The {#delete_attribute} method is used to delete an attribute from an entity.
- `#document` [LayOut 2018] — The {#document} method returns the {Layout::Document} that the {Layout::Entity} belongs to, or +nil+ if it is not in a {Layout::Document}.
- `#drawing_bounds` [LayOut 2018] — The {#drawing_bounds} method returns the 2D rectangular drawing bounds of the {Layout::Entity}.
- `#get_attribute(name, key, default_value = nil)` [LayOut 2026.0] — The {#get_attribute} method is used to retrieve the value of an attribute in the entity's attribute dictionary
- `#group` [LayOut 2018] — The {#group} method returns the {Layout::Group} the {Layout::Entity} belongs to, or +nil+ if it is not in a {Layout::Group}.
- `#layer_instance` [LayOut 2018] — The {#layer_instance} method returns the {Layout::LayerInstance} that the {Layout::Entity} is on, or +nil+ if it is not associated with a {Layout::Lay
- `#locked=(is_locked)` [LayOut 2018] — The {#locked=} method sets the {Layout::Entity} as locked or unlocked
- `#locked?` [LayOut 2018] — The {#locked?} method returns whether the {Layout::Entity} is locked or unlocked.
- `#move_to_group(group)` [LayOut 2018] — The {#move_to_group} method moves the {Layout::Entity} into a {Layout::Group}
- `#move_to_layer(layer)` [LayOut 2018] — The {#move_to_layer} method moves the {Layout::Entity} to the given {Layout::Layer}
- `#on_shared_layer?` [LayOut 2018] — The {#on_shared_layer?} method returns whether or not the {Layout::Entity} is on a shared {Layout::Layer}
- `#page` [LayOut 2018] — The {#page} method returns the {Layout::Page} that the {Layout::Entity} belongs to, or +nil+ if it is on a shared {Layout::Layer} or not in a {Layout:
- `#set_attribute(name, key, value)` [LayOut 2026.0] — The {#set_attribute} method adds an attribute to the entity's attribute dictionary.
- `#style` [LayOut 2018] — The {#style} method returns the {Layout::Style} of the {Layout::Entity}
- `#style=(style)` [LayOut 2018] — The {#style=} method sets the {Layout::Style} of the {Layout::Entity}.
- `#transform!(transformation)` [LayOut 2018] — The {#transform!} method transforms the {Layout::Entity} with a given {Geom::Transformation2d}.
- `#transformation` [LayOut 2018] — The {#transformation} method returns the explicit {Geom::Transformation2d}.
- `#untransformed_bounds` [LayOut 2018] — The {#untransformed_bounds} method returns the untransformed bounds of the {Layout::Entity}
- `#untransformed_bounds=(bounds)` [LayOut 2018] — The {#untransformed_bounds=} method sets the untransformed bounds of the {Layout::Entity}

## Layout::FormattedText < Layout::Entity
_Layout/FormattedText.rb_ [LayOut 2018]

A formatted text entity.

Constants: ANCHOR_TYPE_BOTTOM_CENTER, ANCHOR_TYPE_BOTTOM_LEFT, ANCHOR_TYPE_BOTTOM_RIGHT, ANCHOR_TYPE_CENTER_CENTER, ANCHOR_TYPE_CENTER_LEFT, ANCHOR_TYPE_CENTER_RIGHT, ANCHOR_TYPE_TOP_CENTER, ANCHOR_TYPE_TOP_LEFT, ANCHOR_TYPE_TOP_RIGHT, GROW_MODE_BOUNDED, GROW_MODE_UNBOUNDED

- `.new_from_file(path, bounds)` [LayOut 2018] — The {.new_from_file} method creates a new {Layout::FormattedText} from a text file
- `#append_plain_text(plain_text, style)` [LayOut 2018] — The {#append_plain_text} method appends new text with a given style to the end of the existing plain text of the {Layout::FormattedText}.
- `#apply_style(style, index = 0, length = length_to_end_of_text)` [LayOut 2018] — The {#apply_style} method sets the {Layout::Style} for the text starting at the given character index, and running for the given number of characters.
- `#display_text(page = nil)` [LayOut 2018] — The {#display_text} method returns the display text representation of the {Layout::FormattedText}
- `#grow_mode` [LayOut 2018] — The {#grow_mode} method returns the mode for how the {Layout::FormattedText} sizes itself
- `#grow_mode=(grow_mode)` [LayOut 2018] — The {#grow_mode=} method sets the mode for how the {Layout::FormattedText} sizes itself
- `#initialize(text, bounds)` [LayOut 2018] — The {#initialize} method creates a new {Layout::FormattedText}
- `#plain_text` [LayOut 2018] — The {#plain_text} method returns the plain text representation of the {Layout::FormattedText}.
- `#plain_text=(plain_text)` [LayOut 2018] — The {#plain_text=} method sets the plain text representation of the {Layout::FormattedText}.
- `#rtf` [LayOut 2018] — The {#rtf} method returns the raw RTF representation of the {Layout::FormattedText}.
- `#rtf=(rtf_text)` [LayOut 2018] — The {#rtf=} method sets the raw RTF representation of the {Layout::FormattedText}
- `#style(index = 0, length = 1)` [LayOut 2018] — The {#style} method returns a {Layout::Style} for the text starting at the given character index, and running for the given length.

## Layout::Grid
_Layout/Grid.rb_ [LayOut 2018]

Class that references a {Layout::Document}'s grid settings.

- `#clip_to_margins=(clip)` [LayOut 2020.1] — The {#clip_to_margins=} method sets whether or not the grid is clipped to the page margins.
- `#clip_to_margins?` [LayOut 2020.1] — The {#clip_to_margins?} method returns whether or not the grid is clipped to the page margins.
- `#in_front=(in_front)` [LayOut 2020.1] — The {#in_front=} method sets whether or not the grid is drawn on top of entities.
- `#in_front?` [LayOut 2020.1] — The {#in_front?} method returns whether or not the grid is drawn on top of entities.
- `#major_color` [LayOut 2018] — The {#major_color} method returns the {Sketchup::Color} for the major grid lines.
- `#major_color=(color)` [LayOut 2020.1] — The {#major_color=} method sets the {Sketchup::Color} for the major grid lines.
- `#major_spacing` [LayOut 2018] — The {#major_spacing} method returns the major space size of the {Layout::Grid}.
- `#major_spacing=(spacing)` [LayOut 2020.1] — The {#major_spacing=} method sets the major space size of the {Layout::Grid}.
- `#minor_color` [LayOut 2018] — The {#minor_color} method returns the {Sketchup::Color} for the minor grid lines.
- `#minor_color=(color)` [LayOut 2020.1] — The {#minor_color=} method sets the {Sketchup::Color} for the minor grid lines.
- `#minor_divisions` [LayOut 2018] — The {#minor_divisions} method returns the number of minor divisions of the {Layout::Grid}.
- `#minor_divisions=(divisions)` [LayOut 2020.1] — The {#minor_divisions=} method sets the number of minor divisions of the {Layout::Grid}.
- `#print=(print)` [LayOut 2020.1] — The {#print=} method sets whether or not the {Layout::Grid} is printed.
- `#print?` [LayOut 2018] — The {#print?} method returns whether or not the {Layout::Grid} is printed.
- `#show=(show)` [LayOut 2020.1] — The {#show=} method sets whether or not the {Layout::Grid} is visible.
- `#show?` [LayOut 2018] — The {#show?} method returns whether or not the {Layout::Grid} is visible.
- `#show_major=(show)` [LayOut 2020.1] — The {#show_major=} method sets whether or not the major grid lines are visible.
- `#show_major?` [LayOut 2018] — The {#show_major?} method returns whether or not the major grid lines are visible.
- `#show_minor=(show)` [LayOut 2020.1] — The {#show_minor=} method sets whether or not the minor grid lines are visible.
- `#show_minor?` [LayOut 2018] — The {#show_minor?} method returns whether or not the minor grid lines are visible.

## Layout::Group < Layout::Entity
_Layout/Group.rb_ [LayOut 2018]

A group is a special type of {Layout::Entity} that does not belong to a

Constants: RESIZE_BEHAVIOR_BOUNDS, RESIZE_BEHAVIOR_BOUNDS_AND_FONTS, RESIZE_BEHAVIOR_NONE

- `#entities` [LayOut 2018] — The {#entities} method returns the {Layout::Entities} that belong to the {Layout::Group}.
- `#initialize(entities)` [LayOut 2018] — The {#initialize} method creates a new {Layout::Group}.
- `#remove_scale_factor(resize_behavior)` [LayOut 2018] — The {#remove_scale_factor} method removes the scale factor from the {Layout::Group}
- `#scale_factor` [LayOut 2018] — The {#scale_factor} method returns the scale factor associated with the {Layout::Group}.
- `#scale_precision` [LayOut 2018] — The {#scale_precision} method returns the precision used for the scale of the {Layout::Group}.
- `#scale_precision=(precision)` [LayOut 2018] — The {#scale_precision=} method sets the precision for the scale of the {Layout::Group}.
- `#scale_units` [LayOut 2018] — The {#scale_units} method returns the units format used in the scale for the {Layout::Group}
- `#scale_units=(units_format)` [LayOut 2018] — The {#scale_units=} method sets the units format for the scale of the {Layout::Group}
- `#set_scale_factor(scale_factor, units_format, resize_behavior)` [LayOut 2018] — The {#set_scale_factor} method sets the scale factor for the {Layout::Group}
- `#ungroup` [LayOut 2018] — The {#ungroup} method removes all {Layout::Entity}s from the {Layout::Group} and deletes the {Layout::Group}.

## Layout::Image < Layout::Entity
_Layout/Image.rb_ [LayOut 2018]

A raster image entity.

- `#clip_mask` [LayOut 2018] — The {#clip_mask} method returns the clip mask of the {Layout::Image}, or +nil+ if it does not have a clip mask.
- `#clip_mask=(clip_mask)` [LayOut 2018] — The {#clip_mask=} method sets the clip mask of the {Layout::Image}
- `#initialize(path, bounds)` [LayOut 2018] — The {#initialize} method creates a new {Layout::Image} from a given image file.

## Layout::Label < Layout::Entity
_Layout/Label.rb_ [LayOut 2018]

This is an interface to a label entity. A {Layout::Label} consists of a

Constants: CONNECTION_TYPE_AUTO, CONNECTION_TYPE_BOTTOM_LEFT, CONNECTION_TYPE_BOTTOM_RIGHT, CONNECTION_TYPE_CENTER_LEFT, CONNECTION_TYPE_CENTER_RIGHT, CONNECTION_TYPE_NONE, CONNECTION_TYPE_REVERSE_AUTO, CONNECTION_TYPE_TOP_LEFT, CONNECTION_TYPE_TOP_RIGHT, LEADER_LINE_TYPE_BEZIER, LEADER_LINE_TYPE_SINGLE_SEGMENT, LEADER_LINE_TYPE_TWO_SEGMENT, LEADER_LINE_TYPE_UNKNOWN

- `#connect(connection_point)` [LayOut 2018] — The {#connect} method connects the {Layout::Label} to the given {Layout::ConnectionPoint}
- `#connection_type` [LayOut 2018] — The {#connection_type} method returns the type of the text connection for the {Layout::Label}
- `#connection_type=(connection_type)` [LayOut 2018] — The {#connection_type=} method sets the type of the text connection for the {Layout::Label}
- `#disconnect` [LayOut 2018] — The {#disconnect} method disconnects the {Layout::Label} from its {Layout::ConnectionPoint}
- `#entities` [LayOut 2018] — The {#entities} method returns the {Layout::Entities} that represent the {Layout::Label} in its exploded form.
- `#initialize(text, leader_type, target_point, bounds)` [LayOut 2018] — The {#initialize} method creates a new disconnected {Layout::Label}.
- `#leader_line` [LayOut 2018] — The {#leader_line} method returns a copy of the leader line.
- `#leader_line=(leader_path)` [LayOut 2018] — The {#leader_line=} method sets the leader line.
- `#leader_line_type` [LayOut 2018] — The {#leader_line_type} method returns the type of the leader line for the {Layout::Label}
- `#leader_line_type=(leader_type)` [LayOut 2018] — The {#leader_line_type=} method sets the type of the leader line for the {Layout::Label}
- `#text` [LayOut 2018] — The {#text} method returns a copy of the {Layout::FormattedText} of the {Layout::Label}.
- `#text=(new_text)` [LayOut 2018] — The {#text=} method sets the {Layout::FormattedText} of the {Layout::Label}.

## Layout::Layer
_Layout/Layer.rb_ [LayOut 2018]

This is the interface to a LayOut Layer Definition. A layer definition

Constants: SHARELAYERACTION_CLEAR, SHARELAYERACTION_KEEPONEPAGE, SHARELAYERACTION_MERGEALLPAGES, UNSHARELAYERACTION_CLEAR, UNSHARELAYERACTION_COPYTOALLPAGES, UNSHARELAYERACTION_COPYTOONEPAGE

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Layout::Layer}s are equal
- `#document` [LayOut 2018] — The {#document} method returns the {Layout::Document} that the {Layout::Layer} belongs to.
- `#layer_instance` [LayOut 2018] — The {#layer_instance} method returns a {Layout::LayerInstance} from the {Layout::Layer}
- `#locked=(locked)` [LayOut 2018] — The {#locked=} method sets whether the {Layout::Layer} is locked.
- `#locked?` [LayOut 2018] — The {#locked?} method returns whether the {Layout::Layer} is locked.
- `#name` [LayOut 2018] — The {#name} method returns the name of the {Layout::Layer}.
- `#name=(name)` [LayOut 2018] — The {#name=} sets the name of the {Layout::Layer}.
- `#set_nonshared(page, unshare_action)` [LayOut 2018] — The {#set_nonshared} method sets the {Layout::Layer} to non-shared
- `#set_shared(page, share_action)` [LayOut 2018] — The {#set_shared} method sets the {Layout::Layer} to shared
- `#shared?` [LayOut 2018] — The {#shared?} method returns whether the {Layout::Layer} is shared.

## Layout::LayerInstance
_Layout/LayerInstance.rb_ [LayOut 2018]

References an instance of a {Layout::Layer}. A {Layout::LayerInstance}

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Layout::LayerInstance}s are equal
- `#definition` [LayOut 2018] — The {#definition} method returns the {Layout::Layer} of the {Layout::LayerInstance}.
- `#entities` [LayOut 2018] — The {#entities} method returns the {Layout::Entities} on the {Layout::LayerInstance}.
- `#entity_index(entity)` [LayOut 2018] — The {#entity_index} method returns the index of the {Layout::Entity} on the {Layout::LayerInstance}.
- `#reorder_entity(entity, index)` [LayOut 2018] — The {#reorder_entity} method moves the {Layout::Entity} to the specified index.

## Layout::Layers
_Layout/Layers.rb_ [LayOut 2018]

The Layers class is a container class for all layers in a {Layout::Document}.

- `#[](index)` [LayOut 2018] — The {#[]} method returns a value from the array of {Layout::Layer}s.
- `#active` [LayOut 2018] — The {#active} method returns the active {Layout::Layer} in the {Layout::Document}.
- `#active=(layer)` [LayOut 2018] — The {#active=} method sets the active {Layout::Layer} that will be displayed the next time the {Layout::Document} is opened
- `#add(shared = false)` [LayOut 2018] — The {#add} method adds a new {Layout::Layer} to the {Layout::Document}
- `#each` [LayOut 2018] — The {#each} method iterates through all of the {Layout::Layer}s.
- `#index(layer)` [LayOut 2018] — The {#index} method returns the index of the {Layout::Layer}, or +nil+ if it doesn't exist in the {Layout::Document}.
- `#length` [LayOut 2018] — The {#length} method returns the number of {Layout::Layer}s.
- `#remove(layer, delete_entities = false)` [LayOut 2018] — The {#remove} method deletes the given {Layout::Layer} from the {Layout::Document}.
- `#reorder(layer, new_index)` [LayOut 2018] — The {#reorder} method moves a {Layout::Layer} to a different index within the {Layout::Document}'s list of layers

## Layout::LinearDimension < Layout::Entity
_Layout/LinearDimension.rb_ [LayOut 2018]

References a linear dimension entity. A {Layout::LinearDimension} is composed

Constants: DIMENSION_LINE_ALIGNED, DIMENSION_LINE_HORIZONTAL, DIMENSION_LINE_VERTICAL, LEADER_LINE_TYPE_BEZIER, LEADER_LINE_TYPE_HIDDEN, LEADER_LINE_TYPE_SINGLE_SEGMENT, LEADER_LINE_TYPE_TWO_SEGMENT

- `#auto_scale=(uses_auto_scale)` [LayOut 2018] — The {#auto_scale=} method sets whether the scale for the {Layout::LinearDimension} is set automatically.
- `#auto_scale?` [LayOut 2018] — The {#auto_scale?} method returns whether the scale for the {Layout::LinearDimension} is set automatically.
- `#connect(start_connection, end_connection)` [LayOut 2018] — The {#connect} method connects the {Layout::LinearDimension} to one or two {Layout::Entity}s using the provided {Layout::ConnectionPoint}s
- `#custom_text=(uses_custom_text)` [LayOut 2018] — The {#custom_text=} method sets whether the {Layout::LinearDimension} uses custom text
- `#custom_text?` [LayOut 2018] — The {#custom_text?} method returns whether the {Layout::LinearDimension} uses custom text
- `#disconnect` [LayOut 2018] — The {#disconnect} method disconnects the {Layout::LinearDimension} from its {Layout::ConnectionPoint}s
- `#end_connection_point` [LayOut 2018] — The {#end_connection_point} method returns the paper space location for the second connection.
- `#end_connection_point=(end_point)` [LayOut 2018] — The {#end_connection_point=} method sets the paper space location for the second connection.
- `#end_extent_point` [LayOut 2018] — The {#end_extent_point} method returns the paper space location for the end of the dimension line.
- `#end_extent_point=(end_extent)` [LayOut 2018] — The {#end_extent_point=} method sets the paper space location for the end of the dimension line.
- `#end_offset_length=(offset_length)` [LayOut 2018] — The {#end_offset_length=} method sets the length of the offset from the second {Layout::ConnectionPoint} to the start of the second extension line
- `#end_offset_point` [LayOut 2018] — The {#end_offset_point} method returns the paper space location for the end of the first extension line
- `#entities` [LayOut 2018] — The {#entities} method returns the {Layout::Entities} that represent the {Layout::LinearDimension} in its exploded form
- `#initialize(start_point, end_point, height)` [LayOut 2018] — The {#initialize} method creates a new disconnected {Layout::LinearDimension}.
- `#leader_line_type` [LayOut 2018] — The {#leader_line_type} method returns the type of leader line the {Layout::LinearDimension} is using
- `#leader_line_type=(type)` [LayOut 2018] — The {#leader_line_type=} method sets the type of leader line the {Layout::LinearDimension} is using
- `#leader_line_visible?` [LayOut 2026.0] — The {#leader_line_visible?} method returns whether the leader line is currently visible.
- `#scale` [LayOut 2018] — The {#scale} method returns the scale being used for the {Layout::LinearDimension}.
- `#scale=(scale)` [LayOut 2018] — The {#scale=} method sets the scale being used for the {Layout::LinearDimension}.
- `#start_connection_point` [LayOut 2018] — The {#start_connection_point} method returns the paper space location for the first connection.
- `#start_connection_point=(start_point)` [LayOut 2018] — The {#start_connection_point=} method sets the paper space location for the first connection.
- `#start_extent_point` [LayOut 2018] — The {#start_extent_point} method returns the paper space location for the start of the dimension line.
- `#start_extent_point=(start_extent)` [LayOut 2018] — The {#start_extent_point=} method sets the paper space location for the start of the dimension line.
- `#start_offset_length=(offset_length)` [LayOut 2018] — The {#start_offset_length=} method sets the length of the offset from the first {Layout::ConnectionPoint} to the start of the first extension line
- `#start_offset_point` [LayOut 2018] — The {#start_offset_point} method returns the paper space location for the start of the first extension line
- `#text` [LayOut 2018] — The {#text} method returns a copy of the {Layout::LinearDimension}'s {Layout::FormattedText}.
- `#text=(formatted_text)` [LayOut 2018] — The {#text=} method sets the {Layout::LinearDimension}'s {Layout::FormattedText}.

## Layout::LockedEntityError < ArgumentError
_Layout/LockedEntityError.rb_ [LayOut 2018]

This is raised whenever a method attempts to modify any {Layout::Entity}


## Layout::LockedLayerError < ArgumentError
_Layout/LockedLayerError.rb_ [LayOut 2018]

This is raised whenever a method attempts to modify any {Layout::Entity}


## Layout::Page
_Layout/Page.rb_ [LayOut 2018]

Class for a single page in a LayOut document.

- `#==(other)` [LayOut 2018] — The {#==} method checks to see if the two {Layout::Page}s are equal
- `#attribute_dictionary(name)` [LayOut 2026.0] — The {#attribute_dictionary} method returns a copy of the page's attribute dictionary with the given name.
- `#delete_attribute(dictionary_name)` [LayOut 2026.0] — The {#delete_attribute} method is used to delete an attribute from a page.
- `#document` [LayOut 2018] — The {#document} method returns the {Layout::Document} that the {Layout::Page} belongs to.
- `#entities` [LayOut 2018] — The {#entities} method returns all {Layout::Entity}s that are on the {Layout::Page}
- `#get_attribute(name, key, default_value = nil)` [LayOut 2026.0] — The {#get_attribute} method is used to retrieve the value of an attribute in the page's attribute dictionary
- `#in_presentation=(in_presentation)` [LayOut 2018] — The {#in_presentation=} method sets whether the {Layout::Page} is included in presentations.
- `#in_presentation?` [LayOut 2018] — The {#in_presentation?} method returns whether the {Layout::Page} is included in presentations.
- `#layer_instances` [LayOut 2018] — The {#layer_instances} method returns an array of the {Layout::LayerInstance}s for the {Layout::Page}.
- `#layer_visible?(layer)` [LayOut 2018] — The {#layer_visible?} method returns whether a {Layout::Layer} is visible on the {Layout::Page}.
- `#name` [LayOut 2018] — The {#name} method returns the name of the {Layout::Page}.
- `#name=(name)` [LayOut 2018] — The {#name=} method sets the name of a page.
- `#nonshared_entities` [LayOut 2018] — The {#nonshared_entities} method returns the {Layout::Entities} unique to the {Layout::Page}.
- `#set_attribute(name, key, value)` [LayOut 2026.0] — The {#set_attribute} method adds an attribute to the page's attribute dictionary.
- `#set_layer_visibility(layer, visible)` [LayOut 2018] — The {#set_layer_visibility} method sets whether a {Layout::Layer} is visible on the {Layout::Page}.

## Layout::PageInfo
_Layout/PageInfo.rb_ [LayOut 2018]

This is the interface to a {Layout::Document}'s paper space information. The

Constants: RESOLUTION_HIGH, RESOLUTION_LOW, RESOLUTION_MEDIUM

- `#bottom_margin` [LayOut 2018] — The {bottom_margin} method returns the paper's bottom margin in inches.
- `#bottom_margin=(margin)` [LayOut 2018] — The {#bottom_margin=} method sets the paper's bottom margin in inches.
- `#color` [LayOut 2018] — The {#color} method returns the paper's color.
- `#color=(new_color)` [LayOut 2018] — The {#color=} method sets the paper's color.
- `#display_resolution` [LayOut 2018] — The {#display_resolution} method returns the on screen rendering resolution quality
- `#display_resolution=(resolution)` [LayOut 2018] — The {#display_resolution=} method sets the on screen rendering resolution quality
- `#height` [LayOut 2018] — The {#height} method returns the paper height in inches.
- `#height=(height)` [LayOut 2018] — The {#height=} method sets the paper height in inches.
- `#image_display_resolution` [LayOut 2023.1] — The {#image_display_resolution} method returns the on screen image quality
- `#image_display_resolution=(resolution)` [LayOut 2023.1] — The {#image_display_resolution=} method sets the on screen image quality
- `#image_output_resolution` [LayOut 2023.1] — The {#image_output_resolution} method returns the output image quality
- `#image_output_resolution=(resolution)` [LayOut 2023.1] — The {#image_output_resolution=} method sets the output image quality
- `#left_margin` [LayOut 2018] — The {#left_margin} method returns the paper's left margin in inches.
- `#left_margin=(margin)` [LayOut 2018] — The {#left_margin=} method sets the paper's left margin in inches.
- `#margin_color` [LayOut 2018] — The {#margin_color} method returns the color of the paper's margin.
- `#margin_color=(color)` [LayOut 2018] — The {#margin_color=} sets the color of paper's margin.
- `#output_resolution` [LayOut 2018] — The {#output_resolution} method returns the output rendering resolution quality
- `#output_resolution=(resolution)` [LayOut 2018] — The {#output_resolution=} method sets the output rendering resolution quality
- `#print_margins=(print)` [LayOut 2018] — The {#print_margins=} method sets whether to print the paper's margins.
- `#print_margins?` [LayOut 2018] — The {#print_margins?} method returns whether to print the paper's margins.
- `#print_paper_color=(print_paper_color)` [LayOut 2018] — The {#print_paper_color=} method sets whether or not the page color should be printed.
- `#print_paper_color?` [LayOut 2018] — The {#print_paper_color?} method returns whether or not the page color should be printed.
- `#right_margin` [LayOut 2018] — The {#right_margin} method returns the paper's right margin in inches.
- `#right_margin=(margin)` [LayOut 2018] — The {#right_margin=} sets the paper's right margin in inches.
- `#show_margins=(margins_visible)` [LayOut 2018] — The {#show_margins=} method sets whether the paper's margins are visible.
- `#show_margins?` [LayOut 2018] — The {#show_margins?} method returns whether the paper's margins are visible.
- `#top_margin` [LayOut 2018] — The {#top_margin} method returns the paper's top margin in inches.
- `#top_margin=(margin)` [LayOut 2018] — The {#top_margin} method sets the paper's top margin in inches.
- `#width` [LayOut 2018] — The {#width} method returns the paper width in inches.
- `#width=(width)` [LayOut 2018] — The {#width=} method sets the paper width in inches.

## Layout::Pages
_Layout/Pages.rb_ [LayOut 2018]

The Pages class is a container class for all pages in a {Layout::Document}.

- `#[](index)` [LayOut 2018] — The {#[]} method returns a value from the array of {Layout::Page}s.
- `#add(name = nil)` [LayOut 2018] — The {#add} method adds a new {Layout::Page} to the {Layout::Document}
- `#each` [LayOut 2018] — The {#each} method iterates through all of the {Layout::Page}s.
- `#index(page)` [LayOut 2018] — The {#index} method returns the index of the {Layout::Page}, or +nil+ if it doesn't exist in the {Layout::Document}.
- `#initial` [LayOut 2018] — The {#initial} method returns the initial {Layout::Page} that will be displayed the next time the {Layout::Document} is opened
- `#initial=(page)` [LayOut 2018] — The {#initial=} method sets the initial {Layout::Page} that will be displayed the next time the {Layout::Document} is opened
- `#length` [LayOut 2018] — The {#length} method returns the number of {Layout::Page}s.
- `#remove(page)` [LayOut 2018] — The {#remove} method deletes the given {Layout::Page} from the {Layout::Document}.
- `#reorder(page, new_index)` [LayOut 2018] — The {#reorder} method moves a {Layout::Page} to a different index within the {Layout::Document}'s list of pages

## Layout::Path < Layout::Entity
_Layout/Path.rb_ [LayOut 2018]

A path entity represents a continuous, multi-segment polyline or bezier

Constants: POINT_TYPE_ARC_CENTER, POINT_TYPE_BEZIER_CONTROL, POINT_TYPE_BEZIER_TO, POINT_TYPE_CLOSE, POINT_TYPE_LINE_TO, POINT_TYPE_MOVE_TO, PATH_WINDING_CLOCKWISE, PATH_WINDING_COUNTER_CLOCKWISE, PATH_WINDING_NONE

- `.new_arc(center_point, radius, start_angle, end_angle)` [LayOut 2018] — The {.new_arc} method creates a new arc-shaped {Layout::Path}.
- `#append_point(point)` [LayOut 2018] — The {#append_point} method appends a {Geom::Point2d} to the end of the {Layout::Path}.
- `#arc` [LayOut 2018] — The {#arc} method returns the parameters of an arc from the {Layout::Path}, or +nil+ if path is not an arc.
- `#circle` [LayOut 2018] — The {#circle} method returns the parameters of a circle from the {Layout::Path}, or +nil+ if path is not a circle.
- `#close` [LayOut 2018] — The {#close} method closes the {Layout::Path}.
- `#closed?` [LayOut 2018] — The {#closed?} method returns whether the {Layout::Path} is closed.
- `#end_arrow` [LayOut 2018] — The {#end_arrow} method creates a new {Layout::Path} from an end arrow.
- `#end_point` [LayOut 2018] — The {#end_point} method returns the end point of the {Layout::Path}.
- `#initialize(start_point, end_point)` [LayOut 2018] — The {#initialize} method creates a new {Layout::Path} between a start point and an end point, or from a provided {Layout::Rectangle} or {Layout::Ellip
- `#parametric_length` [LayOut 2018] — The {#parametric_length} method returns the parametric length for the {Layout::Path}
- `#point_at(parametric_value)` [LayOut 2018] — The {#point_at} method returns the {Geom::Point2d} at a given parametric value.
- `#point_types` [LayOut 2018] — The {#point_types} method returns an array of point types corresponding to the {Geom::Point2d}s in the {Layout::Path}
- `#points` [LayOut 2018] — The {#points} method returns an array of {Geom::Point2d}s in the {Layout::Path}.
- `#start_arrow` [LayOut 2018] — The {#start_arrow} method creates a new {Layout::Path} from a start arrow.
- `#start_point` [LayOut 2018] — The {#start_point} method returns the start point of the {Layout::Path}.
- `#tangent_at(parametric_value)` [LayOut 2018] — The {#tangent_at} method returns the tangent {Geom::Vector2d} at the given parametric value.
- `#winding` [LayOut 2019] — The {#winding} method returns the winding type of the {Layout::Path}

## Layout::Rectangle < Layout::Entity
_Layout/Rectangle.rb_ [LayOut 2018]

A simple rectangular shape entity.

Constants: TYPE_BULGED, TYPE_LOZENGE, TYPE_NORMAL, TYPE_ROUNDED

- `#initialize(bounds)` [LayOut 2018] — The {#initialize} method creates a new normal, lozenge, bulged or rounded {Layout::Rectangle}, depending on the type passed in
- `#radius` [LayOut 2018] — The {#radius} method returns the radius of the {Layout::Rectangle}, or +nil+ if the {Layout::Rectangle} is not of type +Layout::Rectangle::TYPE_BULGED
- `#radius=(radius)` [LayOut 2018] — The {#radius=} method sets the radius of the {Layout::Rectangle}.
- `#type` [LayOut 2018] — The {#type} method returns the type of the {Layout::Rectangle}
- `#type=(type)` [LayOut 2018] — The {#type=} method sets the type of the {Layout::Rectangle}

## Layout::ReferenceEntity < Layout::Entity
_Layout/ReferenceEntity.rb_ [LayOut 2023.0]

An entity that represents the data inserted from an external file.

- `#clip_mask` [LayOut 2023.0] — The {#clip_mask} method returns the clip mask of the {Layout::ReferenceEntity}, or +nil+ if it does not have a clip mask.
- `#clip_mask=(clip_mask)` [LayOut 2023.0] — The {#clip_mask=} method sets the clip mask of the {Layout::ReferenceEntity}
- `#entities` [LayOut 2023.0] — The {#entities} method returns the {Layout::Group} that represents the {Layout::ReferenceEntity} in its exploded form.

## Layout::SketchUpModel < Layout::Entity
_Layout/SketchUpModel.rb_ [LayOut 2018]

A SketchUp Model entity. This is an instance of a SketchUp Model that is

Constants: BOTTOM_RELATIVE_VIEW, BOTTOM_VIEW, BACK_VIEW, CUSTOM_VIEW, FRONT_VIEW, HYBRID_RENDER, ISO_VIEW, LEFT_VIEW, NO_OVERRIDE, RASTER_RENDER, RIGHT_VIEW, TOP_RELATIVE_VIEW, TOP_VIEW, VECTOR_RENDER

- `#camera_modified?` [LayOut 2020.1] — The {#camera_modified?} method returns whether the camera of the {Layout::SketchUpModel} has been modified.
- `#clip_mask` [LayOut 2018] — The {#clip_mask} method returns the clip mask entity for the {Layout::SketchUpModel}, or +nil+ if it does not have one
- `#clip_mask=(clip_mask)` [LayOut 2018] — The {#clip_mask=} method sets a clip mask for the {Layout::SketchUpModel}
- `#current_scene` [LayOut 2018] — The {#current_scene} method returns the index of the most recently selected scene of the {Layout::SketchUpModel}.
- `#current_scene=(index)` [LayOut 2018] — The {#current_scene=} method sets the scene of the {Layout::SketchUpModel}.
- `#current_scene_modified?` [LayOut 2018] — The {#current_scene_modified?} method returns whether the most recently selected scene of the {Layout::SketchUpModel} has been modified.
- `#dash_scale` [LayOut 2019] — The {#dash_scale} method returns the dash scale for the {Layout::SketchUpModel}
- `#dash_scale=(dash_scale)` [LayOut 2018] — The {#dash_scale=} method sets the dash scale for the {Layout::SketchUpModel}
- `#display_background=(display)` [LayOut 2018] — The {#display_background=} method sets whether the background is displayed for the {Layout::SketchUpModel}.
- `#display_background?` [LayOut 2018] — The {#display_background?} method returns whether the background is displayed for the {Layout::SketchUpModel}.
- `#effects_modified?` [LayOut 2020.1] — The {#effects_modified?} method returns whether the shadow or fog settings of the {Layout::SketchUpModel} have been modified.
- `#entities` [LayOut 2018] — The {#entities} method returns the {Layout::Group} that represents the {Layout::SketchUpModel} in its exploded form
- `#initialize(path, bounds)` [LayOut 2018] — The {#initialize} method creates a new {Layout::SketchUpModel}.
- `#layers_modified?` [LayOut 2020.1] — The {#layers_modified?} method returns whether the layers of the {Layout::SketchUpModel} has been modified.
- `#line_weight` [LayOut 2018] — The {#line_weight} method returns the line weight for the {Layout::SketchUpModel}.
- `#line_weight=(line_weight)` [LayOut 2018] — The {#line_weight=} method sets the line weight for the {Layout::SketchUpModel}
- `#model_to_paper_point(model_point)` [LayOut 2018] — The {#model_to_paper_point} method converts the {Geom::Point3d} in the {Layout::SketchUpModel} to a {Geom::Point2d} in paper space.
- `#output_entities` [LayOut 2023.1] — The {#output_entities} method returns the {Layout::Group} that represents the {Layout::SketchUpModel} in its exported form
- `#perspective=(perspective)` [LayOut 2018] — The {#perspective=} method sets whether the {Layout::SketchUpModel}'s view is perspective or orthographic.
- `#perspective?` [LayOut 2018] — The {#perspective?} method returns whether the {Layout::SketchUpModel}'s view is perspective or orthographic.
- `#preserve_scale_on_resize=(preserve_scale)` [LayOut 2018] — The {#preserve_scale_on_resize=} method sets whether the scale is preserved when the {Layout::SketchUpModel} is resized.
- `#preserve_scale_on_resize?` [LayOut 2018] — The {#preserve_scale_on_resize?} method returns whether the scale is preserved when the {Layout::SketchUpModel} is resized.
- `#render` [LayOut 2018] — The {#render} method renders the {Layout::SketchUpModel}
- `#render_mode` [LayOut 2018] — The {#render_mode} method returns the render mode of the {Layout::SketchUpModel}
- `#render_mode=(render_mode)` [LayOut 2018] — The {#render_mode=} method sets the render mode of the {Layout::SketchUpModel}
- `#render_needed?` [LayOut 2018] — The {#render_needed?} method returns whether the {Layout::SketchUpModel} needs to be rendered.
- `#reset_camera` [LayOut 2020.1] — The {#reset_camera} method resets the {Layout::SketchUpModel}'s camera to the scene's setting.
- `#reset_effects` [LayOut 2020.1] — The {#reset_effects} method resets the {Layout::SketchUpModel}'s shadow and fog settings to the scene's settings.
- `#reset_layers` [LayOut 2020.1] — The {#reset_layers} method resets the {Layout::SketchUpModel}'s layers to the scene's setting.
- `#reset_style` [LayOut 2020.1] — The {#reset_style} method resets the {Layout::SketchUpModel}'s style to the scene's setting.
- `#scale` [LayOut 2018] — The {#scale} method returns the scale of the {Layout::SketchUpModel}.
- `#scale=(scale)` [LayOut 2018] — The {#scale=} method sets the scale of the {Layout::SketchUpModel}
- `#scenes` [LayOut 2018] — The {#scenes} method returns an array of scene names that are available for the {Layout::SketchUpModel}
- `#style_modified?` [LayOut 2020.1] — The {#style_modified?} method returns whether the style of the {Layout::SketchUpModel} has been modified.
- `#view` [LayOut 2018] — The {#view} method returns the standard view of the {Layout::SketchUpModel}
- `#view=(view)` [LayOut 2018] — The {#view=} method sets the standard view of the {Layout::SketchUpModel}

## Layout::Style
_Layout/Style.rb_ [LayOut 2018]

References a collection of style attributes that determine the visual

Constants: ALIGN_CENTER, ALIGN_LEFT, ALIGN_RIGHT, ANCHOR_BOTTOM, ANCHOR_CENTER, ANCHOR_TOP, ARCHITECTURAL_INCHES, ARROW_FILLED_CIRCLE, ARROW_FILLED_DIAMOND, ARROW_FILLED_SKINNY_TRIANGLE, ARROW_FILLED_SQUARE, ARROW_FILLED_TRIANGLE, ARROW_NONE, ARROW_OPEN_ARROW_120, ARROW_OPEN_ARROW_90, ARROW_OPEN_CIRCLE, ARROW_OPEN_DIAMOND, ARROW_OPEN_SKINNY_TRIANGLE, ARROW_OPEN_SQUARE, ARROW_OPEN_TRIANGLE, ARROW_OVERRUN, ARROW_SLASH_LEFT, ARROW_SLASH_RIGHT, ARROW_STAR, ARROW_T, ARROW_UNDERRUN, CAP_STYLE_FLAT, CAP_STYLE_ROUND, CAP_STYLE_SQUARE, DIMENSION_TEXT_ABOVE, DIMENSION_TEXT_BELOW, DIMENSION_TEXT_CENTER, DIMENSION_TEXT_HORIZONTAL, DIMENSION_TEXT_OFFSET, DIMENSION_TEXT_PARALLEL, DIMENSION_TEXT_PERPENDICULAR, DIMENSION_TEXT_VERTICAL, DECIMAL_CENTIMETERS, DECIMAL_FEET, DECIMAL_INCHES, DECIMAL_METERS, DECIMAL_MILLIMETERS, DECIMAL_POINTS, DEGREES, DIMENSION_END_EXTENSION_LINE, DIMENSION_LEADER_LINE, DIMENSION_LINE, DIMENSION_START_EXTENSION_LINE, DIMENSION_TEXT, ENGINEERING_FEET, FRACTIONAL_INCHES, JOIN_STYLE_BEVEL, JOIN_STYLE_MITER, JOIN_STYLE_ROUND, LABEL_LEADER_LINE, LABEL_TEXT, NORMAL_SCRIPT, RADIANS, STROKE_PATTERN_CENTER, STROKE_PATTERN_DASH, STROKE_PATTERN_DASH_DASH_DOT, STROKE_PATTERN_DASH_DASH_DOT_DOT, STROKE_PATTERN_DASH_DASH_DOT_DOT_DOT, STROKE_PATTERN_DASH_DOT, STROKE_PATTERN_DASH_DOT_DOT, STROKE_PATTERN_DASH_DOT_DOT_DOT, STROKE_PATTERN_DASH_SPACE, STROKE_PATTERN_DOT, STROKE_PATTERN_PHANTOM, STROKE_PATTERN_SHORT_DASH, STROKE_PATTERN_SOLID, STRIKETHROUGH_NONE, STRIKETHROUGH_SINGLE, SUPER_SCRIPT, SUB_SCRIPT, UNDERLINE_DOUBLE, UNDERLINE_NONE, UNDERLINE_SINGLE

- `.arrow_type_filled?(arrow_type)` [LayOut 2018] — The {.arrow_type_filled?} method returns whether the specified arrow type is filled or not
- `#dimension_rotation_alignment` [LayOut 2018] — The {#dimension_rotation_alignment} method returns the rotational text alignment for {Layout::LinearDimension} text, or +nil+ if the {Layout::Style} d
- `#dimension_rotation_alignment=(alignment_type)` [LayOut 2018] — The {#dimension_rotation_alignment=} method sets the rotational text alignment
- `#dimension_units` [LayOut 2018] — The {#dimension_units} method returns the unit format and precision for dimensions, or +nil+ if the {Layout::Style} does not have a value for that set
- `#dimension_vertical_alignment` [LayOut 2018] — The {#dimension_vertical_alignment} method returns the vertical text alignment for {Layout::LinearDimension} text, or +nil+ if the {Layout::Style} doe
- `#dimension_vertical_alignment=(alignment_type)` [LayOut 2018] — The {#dimension_vertical_alignment=} method sets the vertical text alignment for {Layout::LinearDimension} text
- `#end_arrow_size` [LayOut 2018] — The {#end_arrow_size} method returns the size of the end arrow, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#end_arrow_size=(arrow_size)` [LayOut 2018] — The {#end_arrow_size=} method sets the size of the end arrow
- `#end_arrow_type` [LayOut 2018] — The {#end_arrow_type} method returns the type of end arrow, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#end_arrow_type=(arrow_type)` [LayOut 2018] — The {#end_arrow_type=} method sets the type of end arrow
- `#fill_color` [LayOut 2018] — The {#fill_color} method returns the solid file color, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#fill_color=(fill_color)` [LayOut 2018] — The {#fill_color=} method sets the solid fill color.
- `#font_family` [LayOut 2018] — The {#font_family} method returns the text font name, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#font_family=(font_family)` [LayOut 2018] — The {#font_family=} method sets the text font name.
- `#font_size` [LayOut 2018] — The {#font_size} method returns the font size, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#font_size=(font_size)` [LayOut 2018] — The {#font_size=} method sets the font size.
- `#get_sub_style(type)` [LayOut 2018] — The {#get_sub_style} method returns the {Layout::Style} for a sub-entity from the {Layout::Style}
- `#initialize` [LayOut 2018] — The {#initialize} method creates a new {Layout::Style}.
- `#pattern_fill_origin` [LayOut 2018] — The {#pattern_fill_origin} method returns the starting piont for the pattern fill, or +nil+ if the {Layout::Style} does not have a value for that sett
- `#pattern_fill_origin=(origin)` [LayOut 2018] — The {#pattern_fill_origin=} method sets the starting point for the pattern fill.
- `#pattern_fill_path` [LayOut 2018] — The {#pattern_fill_path} method returns the file path to the pattern fill image, or +nil+ if the {Layout::Style} does not have a value for that settin
- `#pattern_fill_path=(path)` [LayOut 2018] — The {#pattern_fill_path=} method sets the path to the image to use for the pattern fill.
- `#pattern_fill_rotation` [LayOut 2018] — The {#pattern_fill_rotation} method returns the rotation of the pattern fill image in degrees, or +nil+ if the {Layout::Style} does not have a value f
- `#pattern_fill_rotation=(rotation)` [LayOut 2018] — The {#pattern_fill_rotation=} method sets the rotation in degrees of the pattern fill image.
- `#pattern_fill_scale` [LayOut 2018] — The {#pattern_fill_scale} method returns the pattern fill scale, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#pattern_fill_scale=(scale)` [LayOut 2018] — The {#pattern_fill_scale=} method sets the pattern fill scale.
- `#pattern_filled` [LayOut 2018] — The {#pattern_filled} method returns whether the {Layout::Style} has a pattern fill, or +nil+ if the {Layout::Style} does not have a value for that se
- `#pattern_filled=(filled)` [LayOut 2018] — The {#pattern_filled=} method sets whether the {Layout::Style} has a pattern fill.
- `#set_dimension_units(units, precision)` [LayOut 2018] — The {#set_dimension_units} method sets the unit format and precision for dimensions
- `#set_sub_style(type, sub_style)` [LayOut 2018] — The {#set_sub_style} method adds a {Layout::Style} to apply to a {Layout::Entity}'s sub-entity
- `#solid_filled` [LayOut 2018] — The {#solid_filled} method returns whether the {Layout::Style} has a solid fill, or +nil+ if the {Layout::Style} does not have a value for that settin
- `#solid_filled=(filled)` [LayOut 2018] — The {#solid_filled=} method sets whether the {Layout::Style} has a solid fill.
- `#start_arrow_size` [LayOut 2018] — The {#start_arrow_size} method returns the size of the start arrow, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#start_arrow_size=(arrow_size)` [LayOut 2018] — The {#start_arrow_size=} method sets the size of the start arrow
- `#start_arrow_type` [LayOut 2018] — The {#start_arrow_type} method returns the type of start arrow, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#start_arrow_type=(arrow_type)` [LayOut 2018] — The {#start_arrow_type=} method sets the type of start arrow
- `#stroke_cap_style` [LayOut 2018] — The {#stroke_cap_style} method returns the stroke cap style, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#stroke_cap_style=(cap_style)` [LayOut 2018] — The {#stroke_cap_style=} method sets the stroke cap style
- `#stroke_color` [LayOut 2018] — The {#stroke_color} method returns the stroke color, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#stroke_color=(stroke_color)` [LayOut 2018] — The {#stroke_color=} method sets the stroke color.
- `#stroke_join_style` [LayOut 2018] — The {#stroke_join_style} method returns the stroke join style, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#stroke_join_style=(join_style)` [LayOut 2018] — The {#stroke_join_style=} method sets the stroke join style
- `#stroke_pattern` [LayOut 2018] — The {#stroke_pattern} method returns the stroke pattern, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#stroke_pattern=(pattern)` [LayOut 2018] — The {#stroke_pattern=} method sets the stroke pattern
- `#stroke_pattern_scale` [LayOut 2018] — The {#stroke_pattern_scale} method returns the stroke pattern scale, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#stroke_pattern_scale=(scale)` [LayOut 2018] — The {#stroke_pattern_scale=} method sets the stroke pattern scale.
- `#stroke_width` [LayOut 2018] — The {#stroke_width} method returns the stroke width, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#stroke_width=(stroke_width)` [LayOut 2018] — The {#stroke_width=} method sets the stroke width.
- `#stroked` [LayOut 2018] — The {#stroked} method returns whether the {Layout::Style} has a stroke, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#stroked=(stroked)` [LayOut 2018] — The {#stroked=} method sets whether the {Layout::Style} has a stroke.
- `#suppress_dimension_units` [LayOut 2018] — The {#suppress_dimension_units} method returns whether the units for dimensions are suppressed, or +nil+ if the {Layout::Style} does not have a value 
- `#suppress_dimension_units=(suppress)` [LayOut 2018] — The {#suppress_dimension_units=} method sets whether the units for dimensions are suppressed.
- `#text_alignment` [LayOut 2018] — The {#text_alignment} method returns the text alignment, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#text_alignment=(alignment_type)` [LayOut 2018] — The {#text_alignment=} method sets the text alignment
- `#text_anchor` [LayOut 2018] — The {#text_anchor} method returns the text anchor type, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#text_anchor=(anchor_type)` [LayOut 2018] — The {#text_anchor=} method sets the text anchor type
- `#text_bold` [LayOut 2018] — The {#text_bold} method returns whether text is bold, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#text_bold=(bold)` [LayOut 2018] — The {#text_bold=} method sets whether text is bold.
- `#text_color` [LayOut 2018] — The {#text_color} method returns the text color, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#text_color=(color)` [LayOut 2018] — The {#text_color=} method sets the text color.
- `#text_elevation` [LayOut 2018] — The {#text_elevation} method returns the text elevation, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#text_elevation=(elevation_type)` [LayOut 2018] — The {#text_elevation=} method sets the text elevation
- `#text_italic` [LayOut 2018] — The {#text_italic} method returns whether text is italic, or +nil+ if the {Layout::Style} does not have a value for that setting.
- `#text_italic=(italic)` [LayOut 2018] — The {#text_italic=} method sets whether text is italic.
- `#text_strikethrough` [LayOut 2026.0] — The {#text_strikethrough} method returns the text strike through type, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#text_strikethrough=(strikethrough_type)` [LayOut 2026.0] — The {#text_strikethrough=} method sets the text strike through type
- `#text_underline` [LayOut 2018] — The {#text_underline} method returns the text underline type, or +nil+ if the {Layout::Style} does not have a value for that setting
- `#text_underline=(underline_type)` [LayOut 2018] — The {#text_underline=} method sets the text underline type

## Layout::Table < Layout::Entity
_Layout/Table.rb_ [LayOut 2018]

A {Layout::Table} is a series of rows and columns that holds data.

- `#[](row_index, column_index)` [LayOut 2018] — The {#[]} method returns the {Layout::TableCell} at the specified row and column.
- `#dimensions` [LayOut 2018] — The {#dimensions} method returns the number of rows and columns in a {Layout::Table}.
- `#each` [LayOut 2018] — The {#each} method iterates in column major order through all of the cells in the {Layout::Table}.
- `#entities` [LayOut 2018] — The {#entities} method creates and returns the {Layout::Entities} that represent the {Layout::Table} in its exploded form.
- `#get_column(index)` [LayOut 2018] — The {#get_column} method returns the {Layout::TableColumn} at the specified index.
- `#get_row(index)` [LayOut 2018] — The {#get_row} method returns the {Layout::TableRow} at the specified index.
- `#initialize(bounds, rows, columns)` [LayOut 2018] — The {#initialize} method creates a {Layout::Table} with a specified size, and a specified number of rows and columns.
- `#insert_column(index)` [LayOut 2018] — The {#insert_column} method inserts a new column at the specified index.
- `#insert_row(index)` [LayOut 2018] — The {#insert_row} method inserts a new row at the specified index.
- `#merge(start_row, start_column, end_row, end_column)` [LayOut 2018] — The {#merge} method merges a range of cells within a {Layout::Table}
- `#remove_column(index)` [LayOut 2018] — The {#remove_column} method removes the column at the specified index.
- `#remove_row(index)` [LayOut 2018] — The {#remove_row} method removes the row at the specified index.

## Layout::TableCell
_Layout/TableCell.rb_ [LayOut 2018]

A {Layout::TableCell} is a single cell from a table that contains data.

Constants: ROTATION_0, ROTATION_180, ROTATION_270, ROTATION_90

- `#data` [LayOut 2018] — The {#data} method creates a copy of the {Layout::FormattedText} for the {Layout::TableCell}.
- `#data=(entity)` [LayOut 2018] — The {#data=} method sets the {Layout::Entity} of a {Layout::TableCell}
- `#rotation` [LayOut 2018] — The {#rotation} method returns the rotation of a {Layout::TableCell}
- `#rotation=(cell_rotation)` [LayOut 2018] — The {#rotation=} method sets the rotation of a {Layout::TableCell}
- `#span` [LayOut 2018] — The {#span} method returns the row and column span of a {Layout::TableCell}

## Layout::TableColumn
_Layout/TableColumn.rb_ [LayOut 2018]

A {Layout::TableColumn} is a single column from a table.

- `#left_edge_style` [LayOut 2018] — The {#left_edge_style} method returns the {Layout::Style} of a {Layout::TableColumn}'s left edge
- `#left_edge_style=(style)` [LayOut 2018] — The {#left_edge_style=} method sets the {Layout::Style} of a {Layout::TableColumn}'s left edge
- `#right_edge_style` [LayOut 2018] — The {#right_edge_style} method returns the {Layout::Style} of a {Layout::TableColumn}'s right edge
- `#right_edge_style=(style)` [LayOut 2018] — The {#right_edge_style=} method sets the {Layout::Style} of a {Layout::TableColumn}'s right edge
- `#width` [LayOut 2018] — The {#width} method returns the width of the {Layout::TableColumn}.
- `#width=(width)` [LayOut 2018] — The {#width=} method sets the width of the {Layout::TableColumn}.

## Layout::TableRow
_Layout/TableRow.rb_ [LayOut 2018]

A {Layout::TableColumn} is a single row from a table.

- `#bottom_edge_style` [LayOut 2018] — The {#bottom_edge_style} method returns the {Layout::Style} of a {Layout::TableRow}'s bottom edge.
- `#bottom_edge_style=(style)` [LayOut 2018] — The {#bottom_edge_style=} method sets the {Layout::Style} of a {Layout::TableRow}'s bottom edge.
- `#height` [LayOut 2018] — The {#height} method returns the height of the {Layout::TableRow}.
- `#height=(height)` [LayOut 2018] — The {#height=} method sets the height of the {Layout::TableRow}.
- `#top_edge_style` [LayOut 2018] — The {#top_edge_style} method returns the {Layout::Style} of a {Layout::TableRow}'s top edge.
- `#top_edge_style=(style)` [LayOut 2018] — The {#top_edge_style=} method sets the {Layout::Style} of a {Layout::TableRow}'s top edge.

## Length < Float
_Length.rb_ [SketchUp 6.0]

Because length units are used so often in SketchUp, a special class has been

- `#<(length2)` [SketchUp 6.0] — The < method is used to see if one length is less than another length
- `#<=(length2)` [SketchUp 6.0] — The <= method is used to see if one length is less than or equal to another length.
- `#<=>(length2)` [SketchUp 6.0] — The <=> method is used to see if one length is less than equal or greater than another length
- `#==(length2)` [SketchUp 6.0] — The == method is used to see if one length is equal to another length
- `#>(length2)` [SketchUp 6.0] — The > method is used to see if one length is greater than another length
- `#>=(length2)` [SketchUp 6.0] — The >= method is used to see if one length is greater than or equal to another length
- `#inspect` [SketchUp 6.0] — The inspect method is used to retrieve an unformatted string for the length, which is the length in inches, regardless of the user's model unit settin
- `#to_f` [SketchUp 6.0] — The to_f method is used to convert a length to a normal float.
- `#to_s` [SketchUp 6.0] — Format a length as a String using the current units formatting settings for the model

## Numeric
_Numeric.rb_ [SketchUp 6.0]

A number of methods have been added to the Ruby Numeric class to do units

- `#cm` [SketchUp 6.0] — The cm method is used to convert from centimeters to inches.
- `#degrees` [SketchUp 6.0] — The degrees method is used to convert from degrees to radians
- `#feet` [SketchUp 6.0] — The feet method is used to convert from feet to inches.
- `#inch` [SketchUp 6.0] — The to_l is used to convert from a number to a length.
- `#km` [SketchUp 6.0] — The km method is used to convert from kilometers to inches.
- `#m` [SketchUp 6.0] — The m method is used to convert from meters to inches.
- `#mile` [SketchUp 6.0] — The mile method is used to convert from miles to inches.
- `#mm` [SketchUp 6.0] — The mm method is used to convert from millimeters to inches
- `#radians` [SketchUp 6.0] — The radians method is used to convert from radians to degrees
- `#to_cm` [SketchUp 6.0] — The to_cm method is used to convert from inches to centimeters.
- `#to_feet` [SketchUp 6.0] — The to_feet method is used to convert from inches to feet.
- `#to_inch` [SketchUp 6.0] — The to_inch method converts from inches to inches
- `#to_km` [SketchUp 6.0] — The to_km method is used to convert from inches to kilometers.
- `#to_l` [SketchUp 6.0] — The to_l is used to convert from a number to a length.
- `#to_m` [SketchUp 6.0] — The to_m method is used to convert from inches to meters.
- `#to_mile` [SketchUp 6.0] — The to_mile method is used to convert from inches to miles.
- `#to_mm` [SketchUp 6.0] — The to_mm method is used to convert from inches to millimeters.
- `#to_yard` [SketchUp 6.0] — The to_yard method is used to convert from inches to yards.
- `#yard` [SketchUp 6.0] — The yard method is used to convert from yards to inches.

## Sketchup
_Sketchup.rb_ [SketchUp 6.0]

The Sketchup module contains a number of important utility methods for use in

- `.active_model` [SketchUp 6.0] — The active_model method returns the currently active SketchUp model
- `.add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `.app_name` [SketchUp 6.0] — The app_name method is used to retrieve the current application name.
- `.break_edges=(enabled)` [SketchUp 7.0] — The break_edges= method can be used to disable or enable the break edges feature
- `.break_edges?` [SketchUp 7.0] — The break_edges? method indicates whether the break edges feature is currently turned on
- `.create_texture_writer` [SketchUp 6.0] — The create_texture_writer method is used to create a TextureWriter object.
- `.debug_mode=(enabled)` [SketchUp 2016] — The debug_mode= method lets you controls whether SketchUp will output warnings to the console when it detects incorrect usage of the API
- `.debug_mode?` [SketchUp 2016] — The debug_mode? controls whether SketchUp will output warnings to the console when it detects incorrect usage of the API.
- `.display_name_from_action(action_name)` [SketchUp 6.0] — The display_name_from_action method is used to gets a user-friendly name from an action string
- `.extensions` [SketchUp 8.0 M2] — Returns the ExtensionsManager where you can find all registered SketchupExtension objects
- `.file_new` [SketchUp 6.0] — The file_new method is used to create a new file.
- `.find_support_file(filename, directory)` [SketchUp 6.0] — The find_support_files method is used to retrieve the relative path and name of a file within the SketchUp installation directory
- `.find_support_files(filename, directory)` [SketchUp 6.0] — The find_support_files method is used to retrieve the path and name of all matching files within the SketchUp installation directory
- `.fix_shadow_strings=(enabled)` [SketchUp 8.0 M1] — The fix_shadow_strings= method lets you control whether shadow rendering attempts to fix an artifact commonly referred to as "strings"
- `.fix_shadow_strings?` [SketchUp 8.0 M1] — The fix_shadow_strings? method indicates whether the a fix for a shadow rendering artifact commonly referred to as "strings" is enabled
- `.focus` [SketchUp 2021.1] — The {.focus} method is used to focus the active model window.
- `.format_angle(number)` [SketchUp 6.0] — The format_angle method takes a number as an angle in radians and formats it into degrees
- `.format_area(number)` [SketchUp 6.0] — The {.format_area} method formats a number as an area using the current units settings
- `.format_degrees(number)` [SketchUp 6.0] — The format_degrees method formats a number as an angle given in degrees
- `.format_length(number)` [SketchUp 6.0] — The {.format_length} method formats a number as a length using the current units settings
- `.format_volume(number)` [SketchUp 2019.2] — The {.format_volume} method formats a number as a volume using the current units settings
- `.get_datfile_info(key, default_value)` [SketchUp 6.0] — The get_datfile_info method is used to retrieve the value for the given key from Sketchup.dat
- `.get_i18n_datfile_info(key, default_value)` [SketchUp 6.0] — The {.get_i18n_datfile_info} method is used to retrieve the value for the given key from the internationalization file that SketchUp uses to work in m
- `.get_locale` [SketchUp 6.0] — The os_language method returns the language code for the language SketchUp is running in
- `.get_resource_path(filename)` [SketchUp 6.0] — The get_resource_path is used to retrieve the directory where "resource" files are stored by SketchUp
- `.get_shortcuts` [SketchUp 6.0] — The get_shortcuts method retrieves an array of all keyboard shortcuts currently registered with SketchUp
- `.install_from_archive(filepath, show_warning = true)` [SketchUp 8.0 M2] — Installs the contents of a ZIP archive file into SketchUp's Plugins folder
- `.is_64bit?` [SketchUp 2015] — This methods indicates whether the host SketchUp application is 64bit
- `.is_online` [SketchUp 6.0] — The is_online method is used to verify a connection to the Internet
- `.is_pro?` [SketchUp 7.0] — Returns a boolean flag indicating whether the application is SketchUp Pro.
- `.is_valid_filename?(filename)` [SketchUp 6.0] — The is_valid_filename? method is used to determine whether a filename contains illegal characters.
- `.load(path)` [SketchUp 6.0] — The {.load} method is used to load Ruby files
- `.open_file(filename)` [SketchUp 2021.0] **DEPRECATED** — The {.open_file} method is used to open a SketchUp model.
- `.os_language` [SketchUp 6.0] — The os_language method returns the language code for the language SketchUp is running in
- `.parse_length(string)` [SketchUp 6.0] — The parse_length method parses a string as a length
- `.platform` [SketchUp 2014] — This methods returns a symbol indicating the current platform
- `.plugins_disabled=(enabled)` [SketchUp 8.0 M2] — The plugins_disabled= method lets you control whether SketchUp will load Ruby scripts from the plugins directory at startup time
- `.plugins_disabled?` [SketchUp 8.0 M2] — The plugins_disabled? method indicates whether Ruby scripts in the plugins directory will be loaded at startup time.
- `.quit` [SketchUp 2014] — The quit method is used to terminate the application
- `.read_default(section, variable, default = nil)` [SketchUp 6.0] — The {.read_default} method is used to retrieve the string associated with a value within the specified sub-section section of a .INI file or registry 
- `.redo` [SketchUp 2021.0] — The redo method is used redo the last transaction on the redo stack.
- `.register_extension(extension, load_on_start = false)` [SketchUp 6.0] — The {.register_extension} method is used to register an extension with SketchUp's Extension Manager.
- `.register_importer(importer)` [SketchUp 6.0] — The register_importer method is used to register an importer with SketchUp.
- `.remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `.require(path)` [SketchUp 6.0] — The {.require} method is used to load Ruby files once
- `.resize_viewport(model, width, height)` [SketchUp 2025.0] — The {.resize_viewport} method changes the pixel size of the viewport and SketchUp window
- `.save_thumbnail(skp_filename, img_filename)` [SketchUp 6.0] — The save_thumbnail method is used to generate a thumbnail for any SKP file - not necessarily the loaded model.
- `.send_action(action)` [SketchUp 6.0] — The send_action method sends a message to the message queue to perform some action asynchronously
- `.send_to_layout(file)` [SketchUp 2018] — The {.send_to_layout} method is used to open a file in LayOut.
- `.set_status_text` [SketchUp 6.0] — The set_status_text method is used to set the text appearing on the status bar within the drawing window
- `.status_text=(status_text)` [SketchUp 6.0] — The status_text= method is used to set the text appearing on the status bar within the drawing window
- `.temp_dir` [SketchUp 2014] — The temp_dir method is used to retrieve the OS temporary directory for the current user
- `.template` [SketchUp 6.0] — The template method is used to get the file name of the current template
- `.template=(filename)` [SketchUp 6.0] — The template= method is used to set the file name of the current template
- `.template_dir` [SketchUp 6.0] — The template_dir is used to retrieve the directory where templates are stored by the SketchUp install
- `.undo` [SketchUp 6.0] — The undo method is used undo the last transaction on the undo stack.
- `.vcb_label=(label_text)` [SketchUp 6.0] — The vcb_label= method is used to set the label that appears on the vcb, or the "value control box", which is another word for the "measurements" text 
- `.vcb_value=(value)` [SketchUp 6.0] — The vcb_value= method is used to set the value that appears on the vcb, or the "value control box", which is another word for the "measurements" text 
- `.version` [SketchUp 6.0] — Gets the current version of sketchup in decimal form.
- `.version_number` [SketchUp 6.0] — Get the current version of sketchup as a whole number for comparisons
- `.write_default(section, key, value)` [SketchUp 6.0] — The {.write_default} method is used to set the string associated with a variable within the specified sub-section of a .plist file on the Mac or the r

## Sketchup::Animation
_Sketchup/Animation.rb_ [SketchUp 6.0]

The {Sketchup::Animation} interface is implemented to create animations

- `#nextFrame(view)` [SketchUp 6.0] — The {#nextFrame} method is invoked by SketchUp to tell the animation to display its next frame
- `#pause` [SketchUp 6.0] — The {#pause} method is invoked by SketchUp when the animation is paused
- `#resume` [SketchUp 6.0] — The {#resume} method is invoked by SketchUp when the animation is resumed after being paused
- `#stop` [SketchUp 6.0] — The {#stop} method is invoked by SketchUp when the animation is stopped

## Sketchup::AppObserver
_Sketchup/AppObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to application events.

- `#expectsStartupModelNotifications` [SketchUp 2014] — The {#expectsStartupModelNotifications} method is called to determine if the observer expects to receive {#onNewModel} and {#onOpenModel} calls for th
- `#onActivateModel(model)` [SketchUp 2015] — The {#onActivateModel} method is called when an open model is activated
- `#onExtensionsLoaded` [SketchUp 2022.0] — The {#onExtensionsLoaded} method is called when SketchUp has finished loading all extensions when the application starts.
- `#onNewModel(model)` [SketchUp 6.0] — The {#onNewModel} method is called when the application creates a new, empty model.
- `#onOpenModel(model)` [SketchUp 6.0] — The {#onOpenModel} method is called when the application opens an existing model.
- `#onQuit` [SketchUp 6.0] — The {#onQuit} method is called when SketchUp closes
- `#onUnloadExtension(extension_name)` [SketchUp 7.0] — The {#onUnloadExtension} method is called when the user turns off a Ruby extension

## Sketchup::ArcCurve < Sketchup::Curve
_Sketchup/ArcCurve.rb_ [SketchUp 6.0]

An ArcCurve is a Curve that makes up part of a circle. This is the

- `#center` [SketchUp 6.0] — The center method is used to retrieve the Point3d that is at the center of the circular arc.
- `#circular?` [SketchUp 2023.1] — Checks if the ArcCurve is a circle.
- `#end_angle` [SketchUp 6.0] — The {#end_angle} method is used to retrieve the angle of the end of the arc measured from the X axis in radians.
- `#normal` [SketchUp 6.0] — The normal method retrieves a Vector3d that is perpendicular to the plane of the arc.
- `#plane` [SketchUp 6.0] — The plane method is used to retrieve the plane of the arc
- `#radius` [SketchUp 6.0] — The radius method is used to retrieve the radius of the arc.
- `#start_angle` [SketchUp 6.0] — The start_angle method is used to retrieve the angle of the start of the arc, measured from the X axis in radians.
- `#xaxis` [SketchUp 6.0] — The xaxis method is used to retrieve the X axis of the coordinate system for the curve
- `#yaxis` [SketchUp 6.0] — The yaxis method is used to retrieve the Y axis of the coordinate system for the curve

## Sketchup::AttributeDictionaries < Sketchup::Entity
_Sketchup/AttributeDictionaries.rb_ [SketchUp 6.0]

The AttributeDictionaries class is a collection of all of the

- `#[](key)` [SketchUp 6.0] — Get an AttributeDictionary by name
- `#count` [SketchUp 2014] — The count method is inherited from the Enumerable mix-in module.
- `#delete(key_or_dict)` [SketchUp 6.0] — The delete method destroys a given AttributeDictionary
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through all of the attributes dictionaries.
- `#length` [SketchUp 2014] — The {#length} method returns the number of attribute dictionary objects in the collection.
- `#size` [SketchUp 2014] — The {#size} method is an alias of {#length}.

## Sketchup::AttributeDictionary < Sketchup::Entity
_Sketchup/AttributeDictionary.rb_ [SketchUp 6.0]

The AttributeDictionary class allows you to attach arbitrary collections of

- `#[](key)` [SketchUp 6.0] — The [] method is used to retrieve the attribute with a given key.
- `#[]=(key, value)` [SketchUp 6.0] — The set value ([]=) method is used to set the value of an attribute with a given key
- `#count` [SketchUp 2014] — The count method is inherited from the Enumerable mix-in module.
- `#delete_key(key)` [SketchUp 6.0] — The delete_key method is used to delete an attribute with a given key.
- `#each` [SketchUp 6.0] — The {#each} method iterate through all of the attributes.
- `#each_key` [SketchUp 6.0] — The {#each_key} method is used to iterate through all of the attribute keys.
- `#each_pair` [SketchUp 6.0] — The {#each_pair} method is an alias for {#each}.
- `#empty?` [SketchUp 2025.0] — The {#empty?} method is used to check if the attribute dictionary is empty.
- `#keys` [SketchUp 6.0] — The keys method is used to retrieve an array with all of the attribute keys.
- `#length` [SketchUp 6.0] — The {#length} method is used to retrieve the size (number of elements) of an attribute dictionary.
- `#name` [SketchUp 6.0] — The name method is used to retrieve the name of an attribute dictionary.
- `#size` [SketchUp 6.0] — The {#size} method is an alias of {#length}.
- `#values` [SketchUp 6.0] — The values method is used to retrieve an array with all of the attribute values.

## Sketchup::Axes < Sketchup::Entity
_Sketchup/Axes.rb_ [SketchUp 2016]

SketchUp's drawing axes consist of three colored lines (red, green, blue),

- `#axes` [SketchUp 2016] — The axes method returns the vectors representing the directions of the axes.
- `#origin` [SketchUp 2016] — The {#origin} method returns the origin of the axes.
- `#set(origin, xaxis, yaxis, zaxis)` [SketchUp 2016] — The {#set} method allows the axes to be manipulated
- `#sketch_plane` [SketchUp 2016] — The sketch_plane method returns a plane representing the ground plane of the axes.
- `#to_a` [SketchUp 2016] — The axes method returns the origin and vectors representing the axes.
- `#transformation` [SketchUp 2016] — The {#transformation} method returns the transformation of the axes
- `#xaxis` [SketchUp 2016] — The {#xaxis} method returns the x axis of the axes.
- `#yaxis` [SketchUp 2016] — The {#yaxis} method returns the y axis of the axes.
- `#zaxis` [SketchUp 2016] — The {#zaxis} method returns the z axis of the axes.

## Sketchup::Behavior < Sketchup::Entity
_Sketchup/Behavior.rb_ [SketchUp 6.0]

The Behavior class is used to control the "behavior" of components, which

- `#always_face_camera=(setting)` [SketchUp 6.0] — The always_face_camera= method is used to set the always_face_camera behavior for a component
- `#always_face_camera?` [SketchUp 6.0] — The always_face_camera? method is used to retrieve the  always_face_camera behavior for a component
- `#cuts_opening=(setting)` [SketchUp 6.0] — The cuts_opening= method is used to set the cut opening behavior for a component.
- `#cuts_opening?` [SketchUp 6.0] — The cuts_opening? method is used to get the status of a component's cut opening behavior.
- `#is2d=(is2d)` [SketchUp 6.0] — The {#is2d=} method is used to set whether the component can glue to other entities or not.
- `#is2d?` [SketchUp 6.0] — The {#is2d?} method is used to get whether the component can glue to other entities or not.
- `#no_scale_mask=(scale_mask)` [SketchUp 7.0] — Sets an integer that is really a bit-by-bit description of which scale tool handles are hidden on a given component
- `#no_scale_mask?` [SketchUp 7.0] — The no_scale_mask? method returns an integer that is a bit-by-bit description of which scale tool handles are hidden when the user selects this single
- `#shadows_face_sun=(status)` [SketchUp 6.0] — The shadows_face_sun= method is used to identify whether the component's shadow will be cast from the component's current position as though the compo
- `#shadows_face_sun?` [SketchUp 6.0] — The shadows_face_sun? method is used to determine whether the component's shadow is being cast from the component's current position (as though the co
- `#snapto` [SketchUp 6.0] — The {#snapto} method is used to see how a component can glue to other entities
- `#snapto=(snapto)` [SketchUp 6.0] — The {#snapto=} method is used to set how a component can glue to other entities

## Sketchup::Camera
_Sketchup/Camera.rb_ [SketchUp 6.0]

The Camera class contains methods for creating and manipulating a camera.

- `#aspect_ratio` [SketchUp 6.0] — The {#aspect_ratio} method is used to retrieve the aspect ratio of the Camera
- `#aspect_ratio=(ratio)` [SketchUp 6.0] — The {#aspect_ratio=} method is used to set the aspect ratio for a Camera
- `#center_2d` [SketchUp 2015] — The {#center_2d} method returns a point with the x and y offset of the camera when it's in two-point perspective or math photo mode
- `#description` [SketchUp 6.0] — The {#description} method is used to retrieve the description for a Camera.
- `#description=(description)` [SketchUp 6.0] — The {#description=} method is used to set the description for the Camera.
- `#direction` [SketchUp 6.0] — The {#direction} method is used to retrieve a Vector3d object in the direction that the Camera is pointing.
- `#eye` [SketchUp 6.0] — The {#eye} method is used to retrieve the eye Point3d object for the Camera.
- `#focal_length(length)` [SketchUp 6.0] — The focal_length method is used to get the focal length in millimeters of perspective Camera
- `#focal_length=(focal_length)` [SketchUp 6.0] — The {#focal_length=} method allows you to set the field of view by specifying a focal length in millimeters
- `#fov` [SketchUp 6.0] — The {#fov} method retrieves the field of view of the Camera
- `#fov=(fov)` [SketchUp 6.0] — The {#fov=} method sets the field of view for a Camera
- `#fov_is_height?` [SketchUp 2015] — The {#fov_is_height?} method indicates whether the field of view is measured vertically, as opposed horizontally.
- `#height` [SketchUp 6.0] — The {#height} method retrieves the height of a Camera
- `#height=(value)` [SketchUp 6.0] — The {#height=} method is used to set the height for the Camera in inches
- `#image_width` [SketchUp 6.0] — The {#image_width} method returns the width of the image, as used to calculate the {#focal_length}
- `#image_width=(image_width)` [SketchUp 6.0] — The {#image_width=} method is used to set the width of the image, as used to calculate the {#focal_length}
- `#initialize` [SketchUp 6.0] — Returns a new camera with eye (where the camera is) and targets (where the camera is looking).
- `#is_2d?` [SketchUp 2015] — The {#is_2d?} method indicates whether the camera mode is two-point perspective or match photo mode, as opposed to a normal perspective or parallel pr
- `#perspective=(perspective)` [SketchUp 6.0] — The {#perspective=} method is used to set whether or not this is a perspective camera or an orthographic camera.
- `#perspective?` [SketchUp 6.0] — The {#perspective?} method is used to determine whether a camera is a perspective or orthographic camera.
- `#scale_2d` [SketchUp 2015] — The {#scale_2d} method returns a float indicating the scaling factor of 2 point perspective cameras
- `#set(eye, target, up)` [SketchUp 6.0] — The {#set} method sets the camera orientation
- `#target` [SketchUp 6.0] — The {#target} method retrieves Point3d that the camera is pointing at.
- `#up` [SketchUp 6.0] — The {#up} method is used to retrieve the up vector for the camera
- `#xaxis` [SketchUp 6.0] — The {#xaxis} method is used to retrieve the x axis of the camera coordinate system
- `#yaxis` [SketchUp 6.0] — The {#yaxis} method retrieves the y axis of the camera coordinate system
- `#zaxis` [SketchUp 6.0] — The {#zaxis} method retrieves the z axis of the camera coordinate system

## Sketchup::ClassificationSchema
_Sketchup/ClassificationSchema.rb_ [SketchUp 2015]

The ClassificationSchema class represent schemas loaded in the model.

- `#<=>(schema2)` [SketchUp 2015] — The <=> method is used to compare two ClassificationSchema objects for sorting
- `#name` [SketchUp 2015] — The name method returns the name of the schema.
- `#namespace` [SketchUp 2015] — The namespace method returns the namespace of the schema.

## Sketchup::Classifications
_Sketchup/Classifications.rb_ [SketchUp 2015]

The Classifications class is a container/manager for all classifications in

- `#[](index_or_name)` [SketchUp 2015] — The [] method is used to get a classification schema by name or index.
- `#each` [SketchUp 2015] — The {#each} method is used to iterate through loaded classification schemas.
- `#keys` [SketchUp 2015] — The keys method is used to get a list of keys in the Classifications class, which are the same as the names of the schemas.
- `#length` [SketchUp 2015] — The {#length} method returns the number of loaded classification schemas.
- `#load_schema(file)` [SketchUp 2015] — The load_schema method is used to load a classification schema into a model.
- `#size` [SketchUp 2015] — The {#size} method returns the number of loaded classification schemas.
- `#unload_schema(schema_name)` [SketchUp 2015] — The unload_schema method is used to unload a classification schema that was previously loaded into a model.

## Sketchup::Color
_Sketchup/Color.rb_ [SketchUp 6.0]

The Color class is used to create and manipulate colors within SketchUp

- `.names` [SketchUp 6.0] — The {.names} method is used to retrieve an array of all color names recognized by SketchUp
- `#==(other)` [SketchUp 2018] — The {#==} method checks to see if the two {Sketchup::Color}s are equal
- `#alpha` [SketchUp 6.0] — The {#alpha} method is used to retrieve the opacity of the color
- `#alpha=(alpha)` [SketchUp 8.0 M1] — The {#alpha=} method is used to set the opacity of the color
- `#blend(color2, weight)` [SketchUp 6.0] — The {#blend} method is used to blend two colors
- `#blue` [SketchUp 6.0] — The {#blue} method is used to retrieve the blue value of a color
- `#blue=(blue)` [SketchUp 6.0] — The {#blue=} method is used to set the blue value of a color
- `#green` [SketchUp 6.0] — The {#green} method is used to retrieve the green value of a color
- `#green=(green)` [SketchUp 6.0] — The {#green=} method is used to set the green component of a RGB Color
- `#initialize(red, green, blue, alpha = 255)` [SketchUp 6.0] — The new method is used to create a new Color object.
- `#red` [SketchUp 6.0] — The {#red} method is used to retrieve the red component of a RGB Color
- `#red=(red)` [SketchUp 6.0] — The {#red=} method is used to set the red component of a RGB Color
- `#to_a` [SketchUp 6.0] — The {#to_a} method is used to convert a Color object to an Array object
- `#to_i` [SketchUp 6.0] — The {#to_i} method is used to convert a Color object to an 32 bit integer.
- `#to_s` [SketchUp 6.0] — The {#to_s} method returns a string representation of the {Sketchup::Color} object, in the form of "Color(255, 255, 255, 255)".

## Sketchup::ComponentDefinition < Sketchup::Drawingelement
_Sketchup/ComponentDefinition.rb_ [SketchUp 6.0]

The {Sketchup::ComponentDefinition} class is used to define the contents for

- `#<=>(compdef2)` [SketchUp 6.0] — The <=> method is used to compare two ComponentDefinition objects for sorting
- `#==(compdef2)` [SketchUp 6.0] — The == method is used to test if two ComponentDefinition objects are the same (based on their address in memory).
- `#add_classification(schema_name, schema_type)` [SketchUp 2015] — The add_classification method is used to add a given classification to the component
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#behavior` [SketchUp 6.0] — The behavior method is used to retrieve the Behavior object associated with a component definition.
- `#count_instances` [SketchUp 6.0] — The count_instances method is used to count the number of unique component instances in a model using this component definition
- `#count_used_instances` [SketchUp 2016] — The count_used_instances method is used to count the total number of component instances in a model using this component definition
- `#description` [SketchUp 6.0] — The description method is used to retrieve the description of the component definition
- `#description=(description)` [SketchUp 6.0] — The description= method is used to set the description for the component definition.
- `#entities` [SketchUp 6.0] — The entities method retrieves a collection of all the entities in the component definition
- `#get_classification_value(path)` [SketchUp 2015] — The get_classification_value method is used to retrieve the value from a classification attribute given a key path.
- `#group?` [SketchUp 6.0] — The group? method is used to determine if this component definition is used to hold the elements of a group.
- `#guid` [SketchUp 6.0] — The guid method is used to retrieve the unique identifier of this component definition
- `#hidden?` [SketchUp 6.0] — The {#hidden?} method is used to determine if this component definition is hidden in the component browser
- `#image?` [SketchUp 6.0] — The image? method is used to determine if this component definition is used to define an image.
- `#insertion_point` [SketchUp 6.0] **DEPRECATED** — The insertion_point method is used to retrieve the Point3d object where the component was inserted.
- `#insertion_point=(point)` [SketchUp 6.0] **DEPRECATED** — Sets the insertion point of your definition.
- `#instances` [SketchUp 6.0] — The instances method is used to return any array of ComponentInstancesfor this ComponentDefinition.
- `#internal?` [SketchUp 6.0] — The internal? method is used to determine if the component definition is internal to the Component Browser
- `#invalidate_bounds` [SketchUp 6.0] — Invalidates the bounding box of your definition
- `#live_component?` [SketchUp 2021.0] — The {#live_component?} method is used to identify Live Components and sub-definitions of Live Components.
- `#load_time` [SketchUp 2025.0] — The {#load_time} method gets the load time of the component definition
- `#name` [SketchUp 6.0] — The name method retrieves the name of the component definition.
- `#name=(name)` [SketchUp 6.0] — The {name=} method is used to set the name of the component definition
- `#path` [SketchUp 6.0] — The path method is used to retrieve the path where the component was loaded.
- `#refresh_thumbnail` [SketchUp 7.0] — The refresh_thumbnail method is used to force SketchUp to regenerate the thumbnail image that appears in the component browser
- `#remove_classification(schema_name, schema_type)` [SketchUp 2015] — The remove_classification method is used to remove a given classification from the component
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#save_as(file_path)` [SketchUp 7.0] — The {#save_as} method is used to save your definition as a SketchUp file at the specified file destination
- `#save_copy(file_path)` [SketchUp 2022.0] — The {#save_copy} method is used to save your definition as a SketchUp file without changing the file path it is already associated with
- `#save_thumbnail(filename)` [SketchUp 7.0] — Saves a component thumbnail image
- `#set_classification_value(path, value)` [SketchUp 2015] — The set_classification_value method is used to set the value of a classification attribute given a key path.
- `#thumbnail_camera` [SketchUp 2023.0] — The {#thumbnail_camera} method is used to retrieve a camera representing the thumbnail associated with the component definition.
- `#thumbnail_camera=(camera)` [SketchUp 2023.0] — The {#thumbnail_camera=} method is used to set the camera for the thumbnail associated with the component definition.

## Sketchup::ComponentInstance < Sketchup::Drawingelement
_Sketchup/ComponentInstance.rb_ [SketchUp 6.0]

The {Sketchup::ComponentInstance} class is used to represent component

- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#definition` [SketchUp 6.0] — The definition method is used to retrieve the component definition for this component instance.
- `#definition=(definition)` [SketchUp 6.0] — The definition= method is used to set the component definition for this component
- `#equals?(instance)` [SketchUp 8.0] — The equals? method is used to determine if a component instance is geometrically equivalent to another instance.
- `#explode` [SketchUp 6.0] — The explode method is used to explode the component instance into separate entities.
- `#glued_to` [SketchUp 6.0] — The {#glued_to} method is used to retrieve the entity that this instance is glued to.
- `#glued_to=(drawing_element)` [SketchUp 6.0] — The {glued_to=} method glues this instance to a drawing element
- `#guid` [SketchUp 2014] — The guid method is used to get the base 64 encoded unique id for this SketchUp object.
- `#intersect(instance)` [SketchUp 8.0] — The intersect method is used to compute the boolean intersection of two instances representing manifold solid volumes (this - arg)
- `#locked=(lock)` [SketchUp 6.0] — The locked= method is used to lock a component instance.
- `#locked?` [SketchUp 6.0] — The locked? method is used to determine if a component instance is locked.
- `#make_unique` [SketchUp 6.0] — The {#make_unique} method is used to create a component definition for this instance that is not used by any other instances
- `#manifold?` [SketchUp 8.0] — The manifold? method is used to determine if an instance is manifold.
- `#move!(transformation)` [SketchUp 6.0] — The {#move!} method is used to set the transformation of this component instance, similarly to {#transformation=} but without recording to the undo st
- `#name` [SketchUp 6.0] — The name method is used to get the name of this instance.
- `#name=(name)` [SketchUp 6.0] — The name method is used to set the name of this instance.
- `#outer_shell(instance)` [SketchUp 8.0] — The outer_shell method is used to compute the outer shell of the two instances representing manifold solid volumes (this || arg)
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#show_differences(instance, verbose)` [SketchUp 8.0] — The show_differences method is used to determine if a component instance is geometrically equivalent to another instance and in addition move the non-
- `#split(instance)` [SketchUp 8.0] — The split method is used to compute the boolean split (map overlay)of the two instances representing manifold solid volumes (this - arg)
- `#subtract(instance)` [SketchUp 8.0] — The subtract method is used to compute the boolean difference of the two instances representing manifold solid volumes (this - arg)
- `#transform!(transform)` [SketchUp 6.0] — Apply a {Geom::Transformation} to a component instance.
- `#transformation` [SketchUp 6.0] — The transformation method is used to retrieve the transformation of this instance.
- `#transformation=(transformation)` [SketchUp 6.0] — The {#transformation=} method is used to set the transformation of this component instance.
- `#trim(instance)` [SketchUp 8.0] — The {#trim} method is used to compute the (non-destructive) boolean difference of the two instances representing manifold solid volumes (this - arg)
- `#union(instance)` [SketchUp 8.0] — The union method is used to compute the boolean union of the two instances representing manifold solid volumes (this | arg)
- `#volume` [SketchUp 8.0] — The volume method is used to compute the volume of this instance if and only if this instance is manifold.

## Sketchup::Console
_Sketchup/Console.rb_ [SketchUp 2014]

The Console class is used by SketchUp to direct $stdout and $stderr to the

- `#clear` [SketchUp 2014] — Clears the contents of SketchUp's Ruby Console.
- `#hide` [SketchUp 2014] — Hides the SketchUp Ruby Console.
- `#show` [SketchUp 2014] — Displays the SketchUp Ruby Console.
- `#visible?` [SketchUp 2014] — Returns the visibility state of the SketchUp Ruby Console.

## Sketchup::ConstructionLine < Sketchup::Drawingelement
_Sketchup/ConstructionLine.rb_ [SketchUp 6.0]

The ConstructionLine class contains methods for modifying construction

- `#direction` [SketchUp 6.0] — The direction method retrieves a 3D vector in the direction of the construction line.
- `#direction=(vector)` [SketchUp 6.0] — The direction= method is used to set the direction of the construction line to a 3D vector.
- `#end` [SketchUp 6.0] — The end method retrieves the end point of a construction line in the form of a 3D point
- `#end=(point)` [SketchUp 6.0] — The end= method is used to set the end point of the construction line
- `#position` [SketchUp 6.0] — The position method is used to retrieve a 3D point used to create a construction line on an infinite construction line.
- `#position=(point)` [SketchUp 6.0] — The position= method is used to set a 3D point that the construction passes through
- `#reverse!` [SketchUp 6.0] — The reverse! method is used to reverse the direction of the construction line.
- `#start` [SketchUp 6.0] — The start method is used to retrieve the starting point of a construction line
- `#start=(point)` [SketchUp 6.0] — The start= method is used to set the start point of a construction line making the line's length finite at the start
- `#stipple` [SketchUp 6.0] — The {#stipple} method is used to retrieve the stipple pattern used to display the construction line.
- `#stipple=(pattern)` [SketchUp 6.0] — The {#stipple=} method is used to set the stipple pattern used to display the construction line

## Sketchup::ConstructionPoint < Sketchup::Drawingelement
_Sketchup/ConstructionPoint.rb_ [SketchUp 6.0]

A construction point represents a point in the model that can be used to aid

- `#position` [SketchUp 6.0] — The position method is used to retrieve a Point3d used to create a construction point.

## Sketchup::Curve < Sketchup::Entity
_Sketchup/Curve.rb_ [SketchUp 6.0]

The Curve class is used by SketchUp to unite a series of Edge objects into

- `#count_edges` [SketchUp 6.0] — The count_edges method is used to retrieve the number of Edge objects that make up the Curve.
- `#each_edge` [SketchUp 6.0] — The each_edge method is used to iterate through all of the Edge objects in the curve.
- `#edges` [SketchUp 6.0] — The edges method is used to retrieve an array of Edge objects that make up the Curve.
- `#first_edge` [SketchUp 6.0] — The first_edge method is used to retrieve the first edge of the curve.
- `#is_polygon?` [SketchUp 7.1 M1] — 
- `#last_edge` [SketchUp 6.0] — The last_edge method is used to retrieve the last edge of the curve.
- `#length` [SketchUp 6.0] — The length method retrieves the length of the curve.
- `#move_vertices(point_array)` [SketchUp 6.0] — The {#move_vertices} method moves the vertices in the curve to points.
- `#vertices` [SketchUp 6.0] — The vertices method retrieves a collection of all vertices in a curve.

## Sketchup::DefinitionList < Sketchup::Entity
_Sketchup/DefinitionList.rb_ [SketchUp 6.0]

A DefinitionList object holds a list of all of the ComponentDefinition

- `#[](index)` [SketchUp 6.0] — The [] method is used to retrieve a component definition from the list
- `#add(def_name)` [SketchUp 6.0] — The add method is used to add a new component definition to the definition list with the given name.
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#[](index)` [SketchUp 6.0] — The [] method is used to retrieve a component definition from the list
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through all of the component definitions in the definition list.
- `#import(path, options = {})` [SketchUp 2021.1] — The {#import} method is used to import a (non-SketchUp) 3d model file as a definition
- `#length` [SketchUp 6.0] — The {#length} method is used to retrieve number of component definitions in the list.
- `#load(path)` [SketchUp 2021.0] — The {#load} method is used to load a component from a file.
- `#load_from_url(url)` [SketchUp 7.0] — The {#load_from_url} method loads a component from a location specified by string url
- `#purge_unused` [SketchUp 6.0] — The purge_unused method is used to remove the unused component definitions.
- `#remove(definition)` [SketchUp 2018] — The {#remove} method is used to remove a component definition from the definition list with the given component definition
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#size` [SketchUp 2014] — The {#size} method is an alias for {#length}.
- `#unique_name(base_name)` [SketchUp 6.0] — The unique_name is used to generate a unique name for a definition based on a base_name string

## Sketchup::DefinitionObserver < Sketchup::EntityObserver
_Sketchup/DefinitionObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to component definition

- `#onComponentInstanceAdded(definition, instance)` [SketchUp 6.0] — The {#onComponentInstanceAdded} method is called when a new component instance is added to a model.
- `#onComponentInstanceRemoved(definition, instance)` [SketchUp 6.0] — The {#onComponentInstanceRemoved} method is called when a component instance is removed from a model.

## Sketchup::DefinitionsObserver
_Sketchup/DefinitionsObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to events on a definitions

- `#onComponentAdded(definitions, definition)` [SketchUp 6.0] — The {#onComponentAdded} method is called whenever a definition is added to the definitions collection.
- `#onComponentPropertiesChanged(definitions, definition)` [SketchUp 6.0] — The {#onComponentPropertiesChanged} method is called whenever a definition's name or description are changed
- `#onComponentRemoved(definitions, definition)` [SketchUp 6.0] — The {#onComponentAdded} method is called whenever a definition is removed from the definitions collection.
- `#onComponentTypeChanged(definitions, definition)` [SketchUp 6.0] — The {#onComponentTypeChanged} event is fired when a component is converted to a group or vice versa

## Sketchup::Dimension < Sketchup::Drawingelement
_Sketchup/Dimension.rb_ [SketchUp 2014]

The Dimension class provides base functionality for classes DimensionLinear

Constants: ARROW_CLOSED, ARROW_DOT, ARROW_NONE, ARROW_OPEN, ARROW_SLASH

- `#add_observer(observer)` [SketchUp 2014] — The add_observer method is used to add a DimensionObserver to the dimension.
- `#arrow_type` [SketchUp 2014] — The {#arrow_type} method retrieves the current arrow type of the dimension
- `#arrow_type=(type)` [SketchUp 2014] — The {#arrow_type=} method sets the arrow type of the dimension
- `#has_aligned_text=(value)` [SketchUp 2014] — The has_aligned_text= method accepts true or false indicating whether the dimension's text is aligned to the dimension or to the screen.
- `#has_aligned_text?` [SketchUp 2014] — The has_aligned_text method is used to determine whether the dimension's text is aligned to the dimension or to the screen.
- `#plane` [SketchUp 2014] — The plane method is used to retrieve the plane of the dimension
- `#remove_observer(observer)` [SketchUp 2014] — The remove_observer method is used to remove a DimensionObserver from the dimension
- `#text` [SketchUp 2014] — The text method is used to retrieve the dimension text.
- `#text=(text)` [SketchUp 2014] — The text= method is used to set an override on the dimension text.

## Sketchup::DimensionLinear < Sketchup::Dimension
_Sketchup/DimensionLinear.rb_ [SketchUp 2014]

The DimensionLinear class represents linear dimensions.

Constants: ALIGNED_TEXT_ABOVE, ALIGNED_TEXT_CENTER, ALIGNED_TEXT_OUTSIDE, TEXT_CENTERED, TEXT_OUTSIDE_END, TEXT_OUTSIDE_START

- `#aligned_text_position` [SketchUp 2014] — The {#aligned_text_position} method returns the text position for dimensions with aligned text (i.e
- `#aligned_text_position=(pos)` [SketchUp 2014] — The {#aligned_text_position=} method is used to set the text position for dimensions with aligned text (i.e
- `#end` [SketchUp 2014] — The end method returns the point or entity the dimension is referencing at its end.
- `#end=(pt_or_entity)` [SketchUp 2014] — The end= method is used to set the end point of the dimension and/or the entity it is referencing.
- `#end_attached_to` [SketchUp 2019] — The {#end_attached_to} method will return the attached end point via an array containing the {Sketchup::InstancePath} and {Geom::Point3d}.
- `#end_attached_to=(path)` [SketchUp 2019] — The {#end_attached_to=} method will attach the ending point to the {Sketchup::InstancePath} and {Geom::Point3d}.
- `#offset_vector` [SketchUp 2014] — The offset_vector method returns the parallel offset vector from the reference line to the dimension line measured from the 'start' reference point.
- `#offset_vector=(offset_vector)` [SketchUp 2014] — The offset_vector= method is used to set the parallel offset vector from the reference line to the dimension line measured from the 'start' reference 
- `#start` [SketchUp 2014] — The start method returns the point or entity the dimension is referencing at its start.
- `#start=(pt_or_entity)` [SketchUp 2014] — The start= method is used to set the start point of the dimension and/or the entity it is referencing.
- `#start_attached_to` [SketchUp 2019] — The {#start_attached_to} method will return the attached start point via an array containing the {Sketchup::InstancePath} and {Geom::Point3d}.
- `#start_attached_to=(path)` [SketchUp 2019] — The {#start_attached_to=} method will attach the starting point to the {Sketchup::InstancePath} and {Geom::Point3d}.
- `#text_position` [SketchUp 2014] — The {#text_position} method returns the position of the text along the dimension line
- `#text_position=(pos)` [SketchUp 2014] — The {#text_position=} method is used to set the position of the text along the dimension line

## Sketchup::DimensionObserver
_Sketchup/DimensionObserver.rb_ [SketchUp 2014]

This observer interface is implemented to react to changes in dimension text.

- `#onTextChanged(dimension)` [SketchUp 2014] — The {#onTextChanged} method is invoked when your entity is erased.

## Sketchup::DimensionRadial < Sketchup::Dimension
_Sketchup/DimensionRadial.rb_ [SketchUp 2014]

The DimensionRadial class represents radius and diameter dimensions on

- `#arc_curve` [SketchUp 2014] — The arc_curve method returns the ArcCurve object to which this dimension is attached.
- `#arc_curve=(arc_curve)` [SketchUp 2014] — The arc_curve= method is used to set the ArcCurve object to which this dimension is attached.
- `#leader_break_point` [SketchUp 2014] — The {#leader_break_point} method returns the break point on the leader where the dimension text is attached.
- `#leader_break_point=(point)` [SketchUp 2014] — The {#leader_break_point=} method is used to set the break point on the leader where the dimension text is attached.
- `#leader_points` [SketchUp 2014] — The leader_points method returns the 3 significant points along the dimension line in world coordinates.

## Sketchup::Drawingelement < Sketchup::Entity
_Sketchup/Drawingelement.rb_ [SketchUp 6.0]

Drawingelement is a base class for an item in the model that can be

- `#bounds` [SketchUp 6.0] — The {#bounds} method is used to retrieve the {Geom::BoundingBox} bounding a {Sketchup::Drawingelement}
- `#casts_shadows=(casts)` [SketchUp 6.0] — The casts_shadows= method is used to set the Drawingelement to cast shadows.
- `#casts_shadows?` [SketchUp 6.0] — The casts_shadows? method is used to determine if the Drawingelement is casting shadows.
- `#erase!` [SketchUp 6.0] — The {#erase!} method is used to erase an element from the model
- `#hidden=(hidden)` [SketchUp 6.0] — The hidden= method is used to set the hidden status for an element.
- `#hidden?` [SketchUp 6.0] — The hidden? method is used to determine if the element is hidden
- `#layer` [SketchUp 6.0] — The layer method is used to retrieve the Layer object of the drawing element.
- `#layer=(layer)` [SketchUp 6.0] — The layer= method is used to set the layer for the drawing element
- `#material` [SketchUp 6.0] — The material method is used to retrieve the material for the drawing element.
- `#material=(material)` [SketchUp 6.0] — The material= method is used to set the material for the drawing element.
- `#receives_shadows=(receive)` [SketchUp 6.0] — The receive_shadows= method is used to set the Drawingelement to receive shadows.
- `#receives_shadows?` [SketchUp 6.0] — The receive_shadows? method is used to determine if the Drawingelement is receiving shadows.
- `#visible=(visibility)` [SketchUp 6.0] — The {#visible=} method is used to set the visible status for an element
- `#visible?` [SketchUp 6.0] — The {#visible?} method checks if a Drawingelement object is not explicitly hidden (i.e

## Sketchup::Edge < Sketchup::Drawingelement
_Sketchup/Edge.rb_ [SketchUp 6.0]

The Edge class contains methods modifying and extracting information for

- `#all_connected` [SketchUp 6.0] — The all_connected method retrieves all of the entities connected to an edge, including the edge itself.
- `#common_face(edge2)` [SketchUp 6.0] — The common_face method is used to identify a face that is common to two edges.
- `#curve` [SketchUp 6.0] — The curve method is used to get the Curve object that this edge belongs to, if any
- `#end` [SketchUp 6.0] — The end method is used to retrieve the Vertex object at the end of the edge.
- `#explode_curve` [SketchUp 6.0] — The explode_curve method is used to explode the curve that the given edge is a part of.
- `#faces` [SketchUp 6.0] — The {#faces} method is used to retrieve all of the faces common to the edge.
- `#find_faces` [SketchUp 6.0] — The find_faces method is used to create all of the Faces that can be created with this edge
- `#length` [SketchUp 6.0] — The {#length} method is used to retrieve the length of an edge in current units
- `#line` [SketchUp 6.0] — The line method is used to retrieve the line defined by the edge
- `#other_vertex(vertex1)` [SketchUp 6.0] — The other_vertex method is used to find the opposite vertex given one vertex of the edge.
- `#reversed_in?(face)` [SketchUp 6.0] — The {#reversed_in?} method is used to determine if the edge is reversed in a face's bounding loop.
- `#smooth=(value)` [SketchUp 6.0] — The {#smooth=} method is used to set the edge to be smooth
- `#smooth?` [SketchUp 6.0] — The {#smooth?} method is used to retrieve the current smooth setting for an edge
- `#soft=(value)` [SketchUp 6.0] — The {#soft=} method is used to set the edge to be soft
- `#soft?` [SketchUp 6.0] — The {#soft?} method is used to retrieve the current soft setting for an edge
- `#split(position)` [SketchUp 6.0] — The {#split} method is used to split an edge into two or more distinct edges
- `#start` [SketchUp 6.0] — The start method is used to retrieve the Vertex object at the start of the edge.
- `#used_by?(element)` [SketchUp 6.0] — The used_by? method is used to see if an edge is used by a given Face or Vertex.
- `#vertices` [SketchUp 6.0] — The vertices method is used to retrieve the vertices on the edge.

## Sketchup::EdgeUse < Sketchup::Entity
_Sketchup/EdgeUse.rb_ [SketchUp 6.0]

The EdgeUse class defines how an Edge is used in the definition of a Face.

- `#edge` [SketchUp 6.0] — The edge method is used to retrieve the edge for the edge use.
- `#end_vertex_normal` [SketchUp 6.0] — The end_vertex_normal method is used to retrieve the vertex normal for the end point of this edgeuse.
- `#face` [SketchUp 6.0] — The face method is used to retrieve the face used by this edge use.
- `#loop` [SketchUp 6.0] — The loop method is used to retrieve the loop for this edge use.
- `#next` [SketchUp 6.0] — The next method is used to retrieve the next edge use in a loop.
- `#partners` [SketchUp 6.0] — The partners method is used to retrieve all of the partner edge uses that uses the same edge.
- `#previous` [SketchUp 6.0] — The previous method is used to retrieve the previous edge use in a loop.
- `#reversed?` [SketchUp 6.0] — The reversed? method is used to determine if the edge direction is opposite of the edge use direction
- `#start_vertex_normal` [SketchUp 6.0] — The start_vertex_normal method is used to retrieve the vertex normal for the start point of this edgeuse.

## Sketchup::Entities
_Sketchup/Entities.rb_ [SketchUp 6.0]

The {Sketchup::Entities} class is a collection of Entity objects, either in a

- `#[](entity_index)` [SketchUp 6.0] — The {#[]} method is used to retrieve an entity by its index in an array of entities
- `#active_section_plane` [SketchUp 2014] — The active_section_plane method is used to access the currently active section plane in the Entities object.
- `#active_section_plane=(sec_plane)` [SketchUp 2014] — The active_section_plane= method is used to set the active section plane in the Entities object.
- `#add_3d_text(string, alignment, font, is_bold = false, is_italic = false, letter_height = 1.0, tolerance = 0.0, z = 0.0, is_filled = true, extrusion = 0.0)` [SketchUp 6.0] — The {#add_3d_text} method is used to create 3D text
- `#add_arc(center, xaxis, normal, radius, start_angle, end_angle)` [SketchUp 6.0] — The add_arc method is used to create an arc curve segment.
- `#add_circle(center, normal, radius, numsegs = 24)` [SketchUp 6.0] — The add_circle method is used to create a circle.
- `#add_cline(start_point, end_point, stipple = '-')` [SketchUp 6.0] — The {#add_cline} method is used to create a construction line
- `#add_cpoint(point)` [SketchUp 6.0] — The add_cpoint method is used to create a construction point.
- `#add_curve(points)` [SketchUp 6.0] — The add_curve method is used to create a curve from a collection of edges
- `#add_dimension_linear(start_pt_or_entity, end_pt_or_entity, offset_vector)` [SketchUp 2014] — The {#add_dimension_linear} method adds a linear dimension to the entities.
- `#add_dimension_radial(arc_curve, leader_break_pt)` [SketchUp 2014] — The add_dimension_radial method adds a radial dimension (i.e arc/circle radius/diameter dimension) to the entities.
- `#add_edges(points)` [SketchUp 6.0] — The {#add_edges} method is used to add a set of connected edges to the {Sketchup::Entities} collection.
- `#add_face(entities)` [SketchUp 6.0] — The add_face method is used to create a face
- `#add_faces_from_mesh(polygon_mesh, smooth_flags = Geom::PolygonMesh::AUTO_SOFTEN|Geom::PolygonMesh::SMOOTH_SOFT_EDGES, f_material = nil, b_material = nil)` [SketchUp 6.0] — The {#add_faces_from_mesh} method is used to add {Sketchup::Face} entities to the collection of entities from a {Geom::PolygonMesh}
- `#add_group(entities)` [SketchUp 6.0] — The {#add_group} method is used to create a new group.
- `#add_image(path, point, width, height = 0.0)` [SketchUp 6.0] — The add_image method is used to add an image to the collection of entities
- `#add_instance(definition, transform)` [SketchUp 6.0] — The {#add_instance} method adds a group or component instance to the collection of entities using an existent definition.
- `#add_line(point1, point2)` [SketchUp 6.0] — The add_line method is used to add an edge to the collection of entities
- `#add_ngon(center, normal, radius, numsides = 24)` [SketchUp 6.0] — The add_ngon method is used to create a multi-sided polygon.
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#add_section_plane(point, vector)` [SketchUp 2014] — Adds a section plane object to the entities
- `#add_snap(position, direction)` [SketchUp 2025.0] — The {#add_snap} method is used to create a new {Sketchup::Snap}.
- `#add_text(text, point, vector)` [SketchUp 2019] — The {#add_text} method adds a note or label text entity to the entities.
- `#at(entity_index)` [SketchUp 6.0] — The {#at} method is an alias for {#[]}.
- `#build` [SketchUp 2022.0] — Creates an {Sketchup::EntitiesBuilder} that can be used to generate bulk geometry with performance in mind
- `#clear!` [SketchUp 6.0] — The clear! method is used to remove all entities from the collection of entities.
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through the entities in the collection of entities.
- `#erase_entities(entities)` [SketchUp 6.0] — The {#erase_entities} method is used to erase one or more entities from the model.
- `#fill_from_mesh(polygon_mesh, weld_vertices = true, smooth_flags = Geom::PolygonMesh::AUTO_SOFTEN|Geom::PolygonMesh::SMOOTH_SOFT_EDGES, f_material = nil, b_material = nil)` [SketchUp 6.0] — The {#fill_from_mesh} method is used to add faces and edges to the collection of entities from a {Geom::PolygonMesh}
- `#intersect_with(recurse, transform1, entities1, transform2, hidden, entities2)` [SketchUp 6.0] — The {#intersect_with} method is used to intersect a Sketchup::Entities, Sketchup::Component, or Sketchup::Group object with a entities object
- `#length` [SketchUp 6.0] — The {#length} method is used to retrieve the number of entities in the collection of entities.
- `#model` [SketchUp 6.0] — The model method is used to retrieve the model that contains the collection of entities.
- `#parent` [SketchUp 6.0] — The parent method is used to retrieve the parent or object that contains the collection of entities
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#size` [SketchUp 2014] — The {#size} method is an alias for the {#length} method.
- `#transform_by_vectors(sub_entities, vectors)` [SketchUp 6.0] — The transform_by_vectors method is used to apply several vectors to several sub-entities all at once.
- `#transform_entities(transform, entities)` [SketchUp 6.0] — The transform_entities method is used to apply a transform to several sub-entities all at once
- `#weld(edges)` [SketchUp 2020.1] — The {#weld} method takes a set of edges and find all possible chains of edges and connect them with a {Sketchup::Curve}

## Sketchup::EntitiesBuilder
_Sketchup/EntitiesBuilder.rb_ [SketchUp 2022.0]

The {Sketchup::EntitiesBuilder} is an interface to generate bulk geometry

- `#add_edge(point1, point2)` [SketchUp 2022.0] — Adds a {Sketchup::Edge} to the {#entities} collection.
- `#add_edges(points)` [SketchUp 2022.0] — Adds a continuous set of {Sketchup::Edge}'s to the {#entities} collection.
- `#add_face(outer_loop)` [SketchUp 2022.0] — Adds a {Sketchup::Face} to the {#entities} collection.
- `#entities` [SketchUp 2022.0] — The {Sketchup::Entities} collection the {Sketchup::EntitiesBuilder} will add the geometry to.
- `#valid?` [SketchUp 2022.0] — Indicates whether the builder object is valid and can be used
- `#vertex_at(position)` [SketchUp 2022.0] — Finds an existing {Sketchup::Vertex} for the given position, otherwise returns +nil+.

## Sketchup::EntitiesObserver
_Sketchup/EntitiesObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to {Sketchup::Entities}

- `#onActiveSectionPlaneChanged(entities)` [SketchUp 2014] — The {#onActiveSectionPlaneChanged} method is invoked when a section plane within this entities is activated or the active one is deactivated.
- `#onElementAdded(entities, entity)` [SketchUp 6.0] — The onElementAdded method is invoked when a single element is added to the {Sketchup::Entities} collection.
- `#onElementModified(entities, entity)` [SketchUp 8.0] — The {#onElementModified} method is invoked whenever one or more elements in the collection are modified.
- `#onElementRemoved(entities, entity_id)` [SketchUp 6.0] — The {#onElementRemoved} method is invoked when a single element is removed from the {Sketchup::Entities} collection
- `#onEraseEntities(entities)` [SketchUp 6.0] — The {#onEraseEntities} method is invoked when one or more entities are erased.

## Sketchup::Entity
_Sketchup/Entity.rb_ [SketchUp 6.0]

This is the base class for all SketchUp entities. Entities are basically

- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#attribute_dictionaries` [SketchUp 6.0] — The attribute_dictionaries method is used to retrieve the AttributeDictionaries collection attached to the entity.
- `#attribute_dictionary(name, create = false)` [SketchUp 6.0] — The attribute_dictionary method is used to retrieve an attribute dictionary with a given name that is attached to an Entity.
- `#delete_attribute(dictionary_name)` [SketchUp 6.0] — The {#delete_attribute} method is used to delete an attribute from an entity
- `#deleted?` [SketchUp 6.0] — The deleted? method is used to determine if your entity is still valid (not deleted by another script, for example.)
- `#entityID` [SketchUp 6.0] — The entityID method is used to retrieve a unique ID assigned to an entity
- `#get_attribute(dict_name, key, default_value = nil)` [SketchUp 6.0] — The {#get_attribute} method is used to retrieve the value of an attribute in the entity's attribute dictionary
- `#inspect` [SketchUp 6.0] — The {#inspect} method is used to retrieve the string representation of the entity.
- `#model` [SketchUp 6.0] — The model method is used to retrieve the model for the entity.
- `#parent` [SketchUp 6.0] — The parent method is used to retrieve the parent of the entity
- `#persistent_id` [SketchUp 2017] — The {#persistent_id} method is used to retrieve a unique persistent id assigned to an entity
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#set_attribute(dict_name, key, value)` [SketchUp 6.0] — The set attribute is used to set the value of an attribute in an attribute dictionary with the given name
- `#to_s` [SketchUp 6.0] — The {#to_s} method is used to retrieve the string representation of the entity.
- `#typename` [SketchUp 6.0] — The typename method retrieves the type of the entity, which will be a string such as "Face", "Edge", or "Group".
- `#valid?` [SketchUp 6.0] — The {#valid?} method is used to determine if your entity is still valid (not deleted by another script, for example)

## Sketchup::EntityObserver
_Sketchup/EntityObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to entity events.

- `#onChangeEntity(entity)` [SketchUp 6.0] — The {#onChangeEntity} method is invoked when your entity is modified.
- `#onEraseEntity(entity)` [SketchUp 6.0] — The {#onEraseEntity} method is invoked when your entity is erased.

## Sketchup::Environment < Sketchup::Entity
_Sketchup/Environment.rb_ [SketchUp 2025.0]

An {Sketchup::Environment} object represents an environment in the model. Environments are used

- `#description` [SketchUp 2025.0] — The {#description} method gets the description for an {Sketchup::Environment}.
- `#description=(description)` [SketchUp 2025.0] — The {#description=} method sets the description for an {Sketchup::Environment}.
- `#linked_sun=(linked_sun)` [SketchUp 2025.0] — The {#linked_sun=} method is used to set if the {Sketchup::Environment} is linked to the sun
- `#linked_sun?` [SketchUp 2025.0] — The {#linked_sun?} method is used to determine if the {Sketchup::Environment} is linked to the sun
- `#linked_sun_position` [SketchUp 2025.0] — The {#linked_sun_position} method is used to get the position of the sun linked to the {Sketchup::Environment}
- `#linked_sun_position=(sun_position)` [SketchUp 2025.0] — The {#linked_sun_position=} method is used to set the position of the sun linked to the {Sketchup::Environment}
- `#name` [SketchUp 2025.0] — The {#name} method retrieves the name of the {Sketchup::Environment}
- `#name=(name)` [SketchUp 2025.0] — The {#name=} method sets the name for an {Sketchup::Environment}.
- `#path` [SketchUp 2025.0] — The {#path} method is used to get the file name of the image or SKE file used for the {Sketchup::Environment}.
- `#reflection_exposure` [SketchUp 2025.0] — The {#reflection_exposure} method is used to get the exposure of the {Sketchup::Environment} for reflections.
- `#reflection_exposure=(reflection_exposure)` [SketchUp 2025.0] — The {#reflection_exposure=} method is used to set the exposure of the {Sketchup::Environment} for reflections.
- `#rotation` — The {#rotation} method is used to get the vertical rotation angle in degrees to apply to the {Sketchup::Environment}.
- `#rotation=(rotation)` [SketchUp 2025.0] — The {#rotation=} method is used to set the the vertical rotation angle in degrees to apply to the {Sketchup::Environment}.
- `#skydome_exposure` [SketchUp 2025.0] — The {#skydome_exposure} method is used to get the exposure of the {Sketchup::Environment}.
- `#skydome_exposure=(skydome_exposure)` [SketchUp 2025.0] — The {#skydome_exposure=} method is used to set the exposure of the {Sketchup::Environment}.
- `#thumbnail` [SketchUp 2025.0] — The {#thumbnail} method is used to get the thumbnail image of the {Sketchup::Environment}.
- `#use_as_skydome=(use_as_skydome)` [SketchUp 2025.0] — The {#use_as_skydome=} method is used to set if the {Sketchup::Environment} is used as a skydome.
- `#use_as_skydome?` [SketchUp 2025.0] — The {#use_as_skydome?} method is used to determine if the {Sketchup::Environment} is used as a skydome.
- `#use_for_reflections=(use_for_reflection)` [SketchUp 2025.0] — The {#use_for_reflections=} method is used to set if the {Sketchup::Environment} is used for reflections.
- `#use_for_reflections?` [SketchUp 2025.0] — The {#use_for_reflections?} method is used to determine if the {Sketchup::Environment} is used for reflections.
- `#write_hdr(path)` [SketchUp 2025.0] — The {#write_hdr} method writes the HDR, EXR or SKE image of the environment to a file in its original file type.

## Sketchup::Environments < Sketchup::Entity
_Sketchup/Environments.rb_ [SketchUp 2025.0]

An {Sketchup::Environments} object is a collection of {Sketchup::Environment} objects.

- `#[](name)` [SketchUp 2025.0] — The {#[]} method is used to retrieve an {Sketchup::Environment} by name.
- `#add(name, path)` [SketchUp 2025.0] — The {#add} method adds an {Sketchup::Environment} to the {Sketchup::Environments}.
- `#add_observer(arg)` [SketchUp 2025.0] — The {#add_observer} method is used to add an observer to the environments collection.
- `#current` [SketchUp 2025.0] — The {#current} method is used to get the current environment in the {Sketchup::Environments}.
- `#current=(environment)` [SketchUp 2025.0] — The {#current=} method is used to set the current environment in the {Sketchup::Environments}.
- `#each` [SketchUp 2025.0] — The {#each} method is used to iterate over all the environments in the {Sketchup::Environments}.
- `#purge_unused` [SketchUp 2025.0] — The {#purge_unused} method is used to remove unused environments.
- `#remove(environment)` [SketchUp 2025.0] — The {#remove} method removes an {Sketchup::Environment} from the {Sketchup::Environments}.
- `#remove_observer(arg)` [SketchUp 2025.0] — The {#remove_observer} method is used to remove an observer from the current object.
- `#size` [SketchUp 2025.0] — The {#size} method retrieves the number of environments in the {Sketchup::Environments}.

## Sketchup::EnvironmentsObserver
_Sketchup/EnvironmentsObserver.rb_ [SketchUp 2025.0]

This observer interface is implemented to react to {Sketchup::Environment} events.

- `#onEnvironmentAdd(environments, environment)` [SketchUp 2025.0] — The {#onEnvironmentAdd} method is called whenever an environment is added to the {Sketchup::Environments}.
- `#onEnvironmentChange(environments, environment)` [SketchUp 2025.0] — The {#onEnvironmentChange} method is called whenever the environment properties are changed.
- `#onEnvironmentRemove(environments, environment)` [SketchUp 2025.0] — The {#onEnvironmentRemove} method is called whenever an environment is removed from the {Sketchup::Environments}.
- `#onEnvironmentSetCurrent(environments, environment)` [SketchUp 2025.0] — The {#onEnvironmentSetCurrent} method is called whenever the current environment is changed.

## Sketchup::ExtensionsManager
_Sketchup/ExtensionsManager.rb_ [SketchUp 8.0 M2]

The ExtensionsManager class provides a way of accessing the

- `#[](index_or_name)` [SketchUp 8.0 M2] — The [] method is used to get an extension by name, index or ID.
- `#count` [SketchUp 8.0 M2] — 
- `#each` [SketchUp 8.0 M2] — The {#each} method is used to iterate through extensions.
- `#keys` [SketchUp 8.0 M2] — The keys method is used to get a list of keys in the ExtensionsManager, which are the same as the names of the extensions.
- `#length` [SketchUp 8.0 M2] — The {#length} method returns the number of {SketchupExtension} objects inside this ExtensionsManager.
- `#size` [SketchUp 8.0 M2] — The {#size} method is an alias of {#length}.

## Sketchup::Face < Sketchup::Drawingelement
_Sketchup/Face.rb_ [SketchUp 6.0]

Faces in SketchUp are flat, 2-sided polygons with 3 or more sides.

- `#all_connected` [SketchUp 6.0] — The all_connected method retrieves all of the entities connected to a face.
- `#area` [SketchUp 6.0] — The area method is used to retrieve the area of a face
- `#back_material` [SketchUp 6.0] — The back_material method is used to retrieve the material assigned to the back side of the face.
- `#back_material=(material)` [SketchUp 6.0] — The back_material= method is used to set the material assigned to the back side of the face.
- `#classify_point(point)` [SketchUp 6.0] — The classify_point method is used to determine if a given Point3d is on the referenced Face
- `#clear_texture_position(front)` [SketchUp 2022.0] — The {#clear_texture_position} method is used to remove any explicit texture positioning for a face and have SketchUp display it with the default textu
- `#clear_texture_projection(frontside)` [SketchUp 2021.1] — The {#clear_texture_projection} method is used to clear the texture projection
- `#coplanar_with?(other_face)` [SketchUp 2025.0] — The {#coplanar_with?} method is used determine whether a face is coplanar with `other_face`.
- `#edges` [SketchUp 6.0] — The edges method is used to get an array of edges that bound the face.
- `#followme(edges)` [SketchUp 6.0] — The {#followme} method is used to create a shape by making the face follow along an array of edges.
- `#get_UVHelper(front = true, back = true)` [SketchUp 6.0] — The get_UVHelper object is used to retrieve a UVHelper object for use in texture manipulation on a face.
- `#get_glued_instances` [SketchUp 7.0 M1] — The get_glued_instances method returns an Array any ComponentInstances that are glued to the face.
- `#get_texture_projection(frontside)` [SketchUp 2014] — The {#get_texture_projection} method will return a vector representing the projection for either the front or back side of the face.
- `#loops` [SketchUp 6.0] — The loops method is used to get an array of all of the loops that bound the face.
- `#material` [SketchUp 6.0] — The material method is used to retrieve the material assigned to the front of the face
- `#material=(material)` [SketchUp 6.0] — The material= method is used to set the material assigned to the front side of the face
- `#mesh(flags = 0)` [SketchUp 6.0] — The mesh method creates a polygon mesh that represents the face
- `#normal` [SketchUp 6.0] — The normal method is used to retrieve the 3D vector normal to the face in the front direction.
- `#outer_loop` [SketchUp 6.0] — This method is used to retrieve the outer loop that bounds the face.
- `#plane` [SketchUp 6.0] — The plane method is used to retrieve the plane of the face
- `#position_material(material, points, on_front)` [SketchUp 6.0] — The {#position_material} method is used to position a material on a face
- `#pushpull(distance, copy = false)` [SketchUp 6.0] — The pushpull method is used to perform a push/pull on a face
- `#reverse!` [SketchUp 6.0] — The reverse! method is used to reverse the face's orientation, meaning the front becomes the back.
- `#set_texture_projection(vector, frontside)` [SketchUp 2014] **DEPRECATED** — The {#set_texture_projection} method is used to set the texture projection direction.
- `#texture_positioned?(front)` [SketchUp 2021.1] — The {#texture_positioned?} method is used to check if the face has a texture that is positioned
- `#texture_projected?(front)` [SketchUp 2021.1] — The {#texture_projected?} method is used to check if the face has a texture that is projected
- `#uv_tile_at(position, front)` [SketchUp 2021.1] — The {#uv_tile_at} method is used to get the corner positions (model and UV) of a UV tile
- `#vertices` [SketchUp 6.0] — The vertices method is used to get an array of all of the vertices that bound the face.

## Sketchup::FrameChangeObserver
_Sketchup/FrameChangeObserver.rb_ 

This observer interface is implemented to react to changes in camera

- `#frameChange(from_scene, to_scene, percent_done)` [SketchUp 6.0] — This callback method is called during a slide show or creation of an animation after the camera has been set up, but before the frame is displayed

## Sketchup::Group < Sketchup::Drawingelement
_Sketchup/Group.rb_ [SketchUp 6.0]

A Group class contains methods for manipulating groups of entities.

- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add a ComponentInstance observer to the group.
- `#copy` [SketchUp 6.0] — The copy method is used to create a new Group object that is a copy of the group.
- `#definition` [SketchUp 2015] — The definition method is used to retrieve the component definition for this group.
- `#description` [SketchUp 6.0] — The description method is used to retrieve the description for the group.
- `#description=(description)` [SketchUp 6.0] — The description= method is used to set the description for the group.
- `#entities` [SketchUp 6.0] — The entities method is used to retrieve a collection of entities in the group.
- `#equals?(group)` [SketchUp 8.0] — The equals? method is used to determine if a group is geometrically equivalent to another group.
- `#explode` [SketchUp 6.0] — The explode method is used to explode the group into individual entities.
- `#glued_to` [SketchUp 2021.1] — The {#glued_to} method is used to retrieve the entity that this group is glued to.
- `#glued_to=(drawing_element)` [SketchUp 2021.1] — The {glued_to=} method glues this group to a drawing element
- `#guid` [SketchUp 2014] — The guid method is used to get the base 64 encoded unique id for this SketchUp object.
- `#intersect(group)` [SketchUp 8.0] — The intersect method is used to compute the boolean intersection of two groups representing manifold solid volumes (this & arg)
- `#local_bounds` [SketchUp 7.0] **DEPRECATED** — The {#local_bounds} method is used to retrieve the {Geom::BoundingBox} bounding the contents of a {Sketchup::Group}, in the group's own internal coord
- `#locked=(lock)` [SketchUp 6.0] — The locked= method is used to lock a group.
- `#locked?` [SketchUp 6.0] — The locked? method is used to determine if a group is locked.
- `#make_unique` [SketchUp 6.0] — The {#make_unique} method is used to force a group to have a unique definition
- `#manifold?` [SketchUp 8.0] — The manifold? method is used to determine if a group is manifold.
- `#move!(transformation)` [SketchUp 6.0] — The {#move!} method is used to set the transformation of this group instance, similarly to {#transformation=} but without recording to the undo stack
- `#name` [SketchUp 6.0] — The name method is used to retrieve the name of the group.
- `#name=(name)` [SketchUp 6.0] — The {#name=} method is used to set the name for the group.
- `#outer_shell(group)` [SketchUp 8.0] — The outer_shell method is used to compute the outer shell of the two groups representing manifold solid volumes (this || arg)
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove a ComponentInstance observer from the group.
- `#show_differences(group, verbose)` [SketchUp 8.0] — The show_differences method is used to determine if a group is geometrically equivalent to another group and in addition move the non- matching and ma
- `#split(group)` [SketchUp 8.0] — The split method is used to compute the boolean split (map overlay) of the two groups representing manifold solid volumes (this ^ arg)
- `#subtract(group)` [SketchUp 8.0] — The subtract method is used to compute the boolean difference of the two groups representing manifold solid volumes (this - arg)
- `#to_component` [SketchUp 6.0] — The to_component method is used to convert the group to a component instance.
- `#transform!(transform)` [SketchUp 6.0] — The transform! method is used to apply a transformation to a group.
- `#transformation` [SketchUp 6.0] — The transformation method is used to retrieve the transformation for the group.
- `#transformation=(transformation)` [SketchUp 6.0] — The {#transformation=} method is used to set the transformation of this group
- `#trim(group)` [SketchUp 8.0] — The {#trim} method is used to compute the (non-destructive) boolean difference of the two groups representing manifold solid volumes (this - arg)
- `#union(group)` [SketchUp 8.0] — The union method is used to compute the boolean union of the two groups representing manifold solid volumes (this | arg)
- `#volume` [SketchUp 8.0] — The volume method is used to compute the volume of this group if and only if this group is manifold.

## Sketchup::Http
_Sketchup/Http.rb_ [SketchUp 2017]

The {Sketchup::Http} module provides interfaces to create asynchronous HTTP

Constants: DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT, STATUS_CANCELED, STATUS_FAILED, STATUS_PENDING, STATUS_SUCCESS, STATUS_UNKNOWN


## Sketchup::Http::Request
_Sketchup/Http/Request.rb_ [SketchUp 2017]

{Sketchup::Http::Request} objects allows you to send HTTP request to HTTP servers.

- `#body` [SketchUp 2017] — Gets the HTTP body that is going to be used when sending the request.
- `#body=(body)` [SketchUp 2017] — Sets the HTTP body that is going to be used when sending the request.
- `#cancel` [SketchUp 2017] — Cancels the request.
- `#headers` [SketchUp 2017] — Returns the HTTP headers that are going to be used when sending the request.
- `#headers=(headers)` [SketchUp 2017] — Sets the HTTP headers that are going to be used when sending the request.
- `#initialize(url, method = Sketchup::Http::GET)` [SketchUp 2017] — The default port is +80+, to use a different port define it in the URL when creating a new {Sketchup::Http::Request}
- `#method` [SketchUp 2017] — Returns the HTTP method that is going to be used when sending the request.
- `#method=(method)` [SketchUp 2017] — Sets the HTTP method that is going to be used when sending the request
- `#set_download_progress_callback` [SketchUp 2017] — Adds a download progress callback block that will get called everytime we have received data from the server until the download finishes.
- `#set_upload_progress_callback` [SketchUp 2017] — Adds a upload progress callback block that will get called everytime we have uploaded data to the server until the upload finishes.
- `#start` [SketchUp 2017] — Starts the request with optionally a response callback block.
- `#status` [SketchUp 2017] — Returns the internal status code
- `#url` [SketchUp 2017] — Returns a copy of the Request's URL.

## Sketchup::Http::Response
_Sketchup/Http/Response.rb_ [SketchUp 2017]

{Sketchup::Http::Response} objects allows you to get the response information from the

- `#body` [SketchUp 2017] — Gets the HTTP body that was received from the server as a string encoded using the charset provided in the +"Content-Type"+ header of the server respo
- `#headers` [SketchUp 2017] — Returns the HTTP headers that were sent by the server.
- `#status_code` [SketchUp 2017] — Returns the HTTP response status code as defined in rfc2616.

## Sketchup::Image < Sketchup::Drawingelement
_Sketchup/Image.rb_ [SketchUp 6.0]

An Image object represents a raster image placed in the Model.

- `#explode` [SketchUp 6.0] — The explode method is used to explode an image into a face with a texture on it
- `#glued_to` [SketchUp 2021.1] — The {#glued_to} method is used to retrieve the entity that this image is glued to.
- `#glued_to=(drawing_element)` [SketchUp 2021.1] — The {glued_to=} method glues this image to a drawing element
- `#height` [SketchUp 6.0] — The height method is used to retrieve the height of the image
- `#height=(height)` [SketchUp 6.0] — The height= method is used to set the height of the image
- `#image_rep` [SketchUp 2018] — The {#image_rep} method returns a copy of a {Sketchup::ImageRep} object representing the pixel data.
- `#normal` [SketchUp 6.0] — The normal method is used to retrieve the 3D Vector that is perpendicular to the plane of the image.
- `#origin` [SketchUp 6.0] — The origin method is used to retrieve the 3D point that defines the origin of the image.
- `#origin=(point)` [SketchUp 6.0] — The {#origin=} method is used to set the 3D point as the origin of the image.
- `#path` [SketchUp 6.0] — The path method is used to retrieve the path of the file defining the image.
- `#pixelheight` [SketchUp 6.0] — The pixelheight method is used to retrieve the height of the image file in pixels.
- `#pixelwidth` [SketchUp 6.0] — The pixelwidth method is used to retrieve the width of the image file in pixels.
- `#size=(width, height)` [SketchUp 6.0] — The size= method is used to set the width and height of the image, in inches.
- `#transform!(transform)` [SketchUp 6.0] — The transform! method is used to apply a transformation to the image.
- `#transformation` [SketchUp 2014] — The transformation method is used to retrieve the transformation for the image.
- `#transformation=(transform)` [SketchUp 2014] — The transformation= method is used to set the transformation for the image.
- `#width` [SketchUp 6.0] — The width method is used to retrieve the width of the image
- `#width=(width)` [SketchUp 6.0] — The width= method is used to set the width of the image
- `#zrotation` [SketchUp 6.0] — The zrotation method is used to get the angle that the image is rotated about the normal vector from an arbitrary X axis.

## Sketchup::ImageRep
_Sketchup/ImageRep.rb_ [SketchUp 2018]

References an image representation object.

- `#bits_per_pixel` [SketchUp 2018] — The {#bits_per_pixel} method gets the number of bits per pixel in the image.
- `#color_at_uv(u, v, bilinear = false)` [SketchUp 2018] — The {#color_at_uv} method returns a color corresponding to the UV texture coordinates
- `#colors` [SketchUp 2018] — The {#colors} method returns an array of {Sketchup::Color} for each pixel in the image.
- `#data` [SketchUp 2018] — The {#data} method gets the pixel data for an image in a string of bytes.
- `#height` [SketchUp 2018] — The {#height} method returns the height of an image.
- `#initialize` [SketchUp 2018] — The {#initialize} method creates a new image object
- `#load_file(filepath)` [SketchUp 2018] — The {#load_file} method loads image data from the specified file.
- `#row_padding` [SketchUp 2018] — The {#row_padding} method returns the size of the row padding of an image in bytes.
- `#save_file(filepath)` [SketchUp 2018] — The {#save_file} method saves an image data object to an image file specified by a path.
- `#set_data(width, height, bits_per_pixel, row_padding, pixel_data)` [SketchUp 2018] — The {#set_data} method discards any existing data and sets new pixel data for the {Sketchup::ImageRep}.
- `#size` [SketchUp 2018] — The {#size} method gets the total size of the image data in bytes.
- `#width` [SketchUp 2018] — The {#width} method returns the width of an image.

## Sketchup::Importer
_Sketchup/Importer.rb_ [SketchUp 6.0]

The Importer interface lets you build your own importers for SketchUp. To

- `#description` [SketchUp 6.0] — This method is called by SketchUp to determine the description that appears in the File > Import dialog's pulldown list of valid importers
- `#do_options` [SketchUp 6.0] — This method is called by SketchUp when the user clicks on the "Options" button inside the File > Import dialog
- `#file_extension` [SketchUp 6.0] — This method is called by SketchUp to determine a single file extension is associated with your importer
- `#id` [SketchUp 6.0] — This method is called by SketchUp to determine a unique identifier for your importer, typically something like "com.sketchup.importers.dxf".
- `#load_file(file_path, status)` [SketchUp 6.0] — This method is called by SketchUp after the user has selected a file to import
- `#supports_options?` [SketchUp 6.0] — This method is called by SketchUp to determine if the "Options" button inside the File > Import dialog should be enabled while your importer is select

## Sketchup::InputPoint
_Sketchup/InputPoint.rb_ [SketchUp 6.0]

The {Sketchup::InputPoint} class is used to pick 3d points and/or entities

- `#==(inputpoint2)` [SketchUp 6.0] — The == method is used to determine if two input points are the same.
- `#clear` [SketchUp 6.0] — The clear method is used to clear the input point
- `#copy!(inputpoint)` [SketchUp 6.0] — The copy! method is used to copy the data from a second input point into this input point.
- `#degrees_of_freedom` [SketchUp 6.0] — The degrees_of_freedom method retrieves the number of degrees of freedom there are for an input point
- `#depth` [SketchUp 6.0] — The depth method retrieves the depth of an inference if it is coming from a component
- `#display?` [SketchUp 6.0] — The display? method is used to determine if the input point has anything to draw
- `#draw(view)` [SketchUp 6.0] — The draw method is used to draw the input point
- `#edge` [SketchUp 6.0] — The edge method is used to retrieve the edge if the input point is getting its position from a point on an Edge.
- `#face` [SketchUp 6.0] — The face method retrieves the face at or behind the input point
- `#initialize()` [SketchUp 6.0] — The new method is used to create a new InputPoint object.
- `#instance_path` [SketchUp 2017] — The {#instance_path} method retrieves the instance path for the picked point
- `#pick(view, x, y)` [SketchUp 6.0] — The {#pick} method is used to get a input point at a specific screen position.
- `#position` [SketchUp 6.0] — The position method is used to get the 3D point from the input point.
- `#tooltip` [SketchUp 6.0] — The tooltip method is used to retrieve the string that is the tool tip to display for the input point.
- `#transformation` [SketchUp 6.0] — The transformation method retrieves the Transformation object for the input point
- `#valid?` [SketchUp 6.0] — The valid? method is used to determine if an input point has valid data
- `#vertex` [SketchUp 6.0] — The vertex method returns a Vertex associated with the InputPoint

## Sketchup::InstanceObserver < Sketchup::EntityObserver
_Sketchup/InstanceObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to component instance

- `#onClose(instance)` [SketchUp 6.0] — The {#onClose} method is called when an instance is "closed," meaning an end user was editing a component's geometry and then exited back into the par
- `#onOpen(instance)` [SketchUp 6.0] — The {#onOpen} method is called when an instance is "opened," meaning an end user has double clicked on it to edit its geometry

## Sketchup::InstancePath
_Sketchup/InstancePath.rb_ [SketchUp 2017]

The {Sketchup::InstancePath} class represent the instance path to a given

- `#==(other)` [SketchUp 2017] — Instance Methods
- `#[](index)` [SketchUp 2017] — The elements of an instance path can be accessed similarly to an array.
- `#each` [SketchUp 2017] — The yielded entities will start with the root and end with the leaf.
- `#empty?` [SketchUp 2017] — 
- `#include?(object)` [SketchUp 2017] — Returns `true` if the instance path contain the given object.
- `#initialize(path)` [SketchUp 2017] — 
- `#leaf` [SketchUp 2017] — The leaf of an instance path is the last element which can be any entity that can be represented in the model
- `#length` [SketchUp 2017] — {#length} is an alias of {#size}.
- `#persistent_id_path` [SketchUp 2017] — The serialized version of an instance path is the persistent ids of its entities concatenated with a period.
- `#root` [SketchUp 2017] — The root of an instance path is the element located closest to the model root
- `#size` [SketchUp 2017] — 
- `#to_a` [SketchUp 2017] — 
- `#transformation` [SketchUp 2017] — 
- `#valid?` [SketchUp 2017] — An instance path is valid if it has at least one element and consist of groups and instances with exception of the leaf which can be any entity

## Sketchup::Layer < Sketchup::Entity
_Sketchup/Layer.rb_ [SketchUp 6.0]

The Layer class contains methods modifying and extracting information for a

- `#<=>(layer2)` [SketchUp 6.0] — The {#<=>} method is used to compare two layers based on their names
- `#==(other)` [SketchUp 6.0] — The {#==} method is used to determine if two layers are the same.
- `#color` [SketchUp 2014] — The {#color} method is used to retrieve the color of the layer.
- `#color=(color)` [SketchUp 2014] — The {#color=} method is used to set the color of a layer.
- `#display_name` [SketchUp 2020.0] — The {#display_name} method is used to retrieve the display name of the layer
- `#folder` [SketchUp 2021.0] — The {#folder} method is used to return the parent layer folder of a layer.
- `#folder=(parent)` [SketchUp 2021.0] — The {#folder=} method is used to set the parent layer folder of a layer
- `#line_style` [SketchUp 2019] — The {#line_style} method retrieves the line style on this layer.
- `#line_style=(line_style)` [SketchUp 2019] — The {#line_style=} method lets you set a specific line style to a layer
- `#name` [SketchUp 6.0] — The {#name} method return the internal name of the layer which is handled by the model
- `#name=(name)` [SketchUp 6.0] — The {#name=} method is used to set the name of a layer.
- `#page_behavior` [SketchUp 6.0] — The {#page_behavior} method is used to retrieve the visibility behavior of the layer for new pages and existing pages
- `#page_behavior=(page_behavior)` [SketchUp 6.0] — The {#page_behavior=} method is used to control the layer's visibility behavior on existing and new pages
- `#visible=(visible)` [SketchUp 6.0] — The {#visible=} method is used to set if the layer is visible.
- `#visible?` [SketchUp 6.0] — The {#visible?} method is used to determine if the layer is visible.

## Sketchup::LayerFolder < Sketchup::Entity
_Sketchup/LayerFolder.rb_ [SketchUp 2021.0]

Allows layers to be organized in folders. Folders may have duplicate names.

- `#<=>(other)` [SketchUp 2021.0] — The {#<=>} method is used to compare two layer folders based on their names
- `#==(other)` [SketchUp 2021.0] — The {#==} method is used to determine if two layer folders are the same.
- `#add_folder(name)` [SketchUp 2021.0] — The {#add_folder} method adds or moves a layer folder.
- `#add_layer(layer)` [SketchUp 2021.0] — The {#add_layer} method adds a layer to a folder.
- `#count_folders` [SketchUp 2021.0] — The {#count_folders} method retrieves the number of child folders in the folder.
- `#count_layers` [SketchUp 2021.0] — The {#count_layers} method retrieves the number of layers in the folder.
- `#each_folder` [SketchUp 2021.0] — The {#each_folder} method is used to iterate through the folders that are direct children to the folder.
- `#each_layer` [SketchUp 2021.0] — The {#each_layer} method is used to iterate through the layers that are direct children to the folder.
- `#folder` [SketchUp 2021.0] — The {#folder} method is used to return the parent layer folder of a layer folder.
- `#folder=(parent)` [SketchUp 2021.0] — The {#folder=} method is used to set the parent layer folder of a layer folder
- `#folders` [SketchUp 2021.0] — The {#folders} returns the direct child-folders of the folder.
- `#layers` [SketchUp 2021.0] — The {#layers} method retrieves the child layers of a folder.
- `#name` [SketchUp 2021.0] — The {#name} method gets the name of the folder.
- `#name=(name)` [SketchUp 2021.0] — The {#name=} method sets the name of the folder.
- `#remove_folder(folder)` [SketchUp 2021.0] — The {#remove_folder} method removes the folder from the model
- `#remove_layer(layer)` [SketchUp 2021.0] — The {#remove_layer} method removes a layer from a folder
- `#visible=(visible)` [SketchUp 2021.0] — The {#visible=} method is used to set if the layer folder is visible.
- `#visible?` [SketchUp 2021.0] — The {#visible?} method is used to determine if the layer folder is visible.
- `#visible_on_new_pages=(visible)` [SketchUp 2021.0] — The {#visible_on_new_pages=} method is used to set if the layer folder is by default visible on new pages.
- `#visible_on_new_pages?` [SketchUp 2021.0] — The {#visible_on_new_pages?} method is used to determine if the layer folder is by default visible on new pages.

## Sketchup::Layers < Sketchup::Entity
_Sketchup/Layers.rb_ [SketchUp 6.0]

The Layers collection allows you to see and manage all of the layers in a

- `#[](index_or_name)` [SketchUp 6.0] — The {#[]} method is used to retrieve a layer by index or name.
- `#add(layer_name)` [SketchUp 6.0] — The {#add} method is used to add a new layer
- `#add_folder(name)` [SketchUp 2021.0] — The {#add_folder} method adds or moves a layer folder.
- `#add_observer(observer)` [SketchUp 6.0] — The {#add_observer} method is used to add an observer to the layers collection.
- `#at(index_or_name)` [SketchUp 6.0] — The {#at} method is an alias for {#[]}.
- `#count` [SketchUp 6.0] — 
- `#count_folders` [SketchUp 2021.0] — The {#count_folders} method counts the number of folders which are direct children of the layer manager.
- `#count_layers` [SketchUp 2021.0] — The {#count_layers} method retrieves the number of layers not in a folder.
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through all of the layers in the model
- `#each_folder` [SketchUp 2021.0] — The {#each_folder} method is used to iterate through the folders that are direct children to the layer manager.
- `#each_layer` [SketchUp 2021.0] — The {#each_layer} method is used to iterate through the layers that are not inside a layer folder.
- `#folders` [SketchUp 2021.0] — The {#folders} method returns the folders of the layer manager.
- `#layers` [SketchUp 2021.0] — The {#layers} method retrieves the layers not in a folder.
- `#length` [SketchUp 6.0] — The {#length} method retrieves the number of layers.
- `#purge_unused` [SketchUp 6.0] — The {#purge_unused} method is used to remove unused layers.
- `#purge_unused_folders` [SketchUp 2021.0] — The {#purge_unused_folders} method is used to remove all layer folder with no children.
- `#remove(layer, remove_geometry = false)` [SketchUp 2015] — Remove the given layer from the model, optionally removing the geometry.
- `#remove_folder(folder)` [SketchUp 2021.0] — The {#remove_folder} method removes the folder from the model
- `#remove_observer(observer)` [SketchUp 6.0] — The {#remove_observer} method is used to remove an observer from the current object.
- `#size` [SketchUp 2014] — The {#size} method is an alias of {#length}.
- `#unique_name` [SketchUp 6.0] — The {#unique_name} method can be used to get a string that will be a unique layer name inside this collection.

## Sketchup::LayersObserver
_Sketchup/LayersObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to layers events.

- `#onCurrentLayerChanged(layers, layer)` [SketchUp 6.0] — The {#onCurrentLayerChanged} method is called when the user selects a different active layer.
- `#onLayerAdded(layers, layer)` [SketchUp 6.0] — The {#onLayerAdded} method is called when a new layer is added to a model.
- `#onLayerChanged(layers, layer)` [SketchUp 2014] — The {#onLayerChanged} method is called when a layer is changed.
- `#onLayerFolderAdded(layers, layer_folder)` [SketchUp 2021.0] — The {#onLayerFolderAdded} method is called when a layer folder is added to a model.
- `#onLayerFolderChanged(layers, layer_folder)` [SketchUp 2021.0] — The {#onLayerFolderChanged} method is called when a layer folder changes one of its properties.
- `#onLayerFolderRemoved(layers, layer_folder)` [SketchUp 2021.0] — The {#onLayerFolderRemoved} method is called when a layer folder is removed from a model.
- `#onLayerRemoved(layers, layer)` [SketchUp 6.0] — The {#onLayerRemoved} method is called when a layer is removed from a model.
- `#onParentFolderChanged(layers, layer)` [SketchUp 2021.0] — The {#onParentFolderChanged} method is called when a layer changes parent folder.
- `#onRemoveAllLayers(layers)` [SketchUp 6.0] — The {#onRemoveAllLayers} method is called when all layer are removed from a model.

## Sketchup::Licensing
_Sketchup/Licensing.rb_ [SketchUp 2015]

The +Sketchup::Licensing+ module contains methods for

Constants: EXPIRED, LICENSED, NOT_LICENSED, TRIAL, TRIAL_EXPIRED

- `.get_extension_license(extension_id)` [SketchUp 2015] — Gets a license for a given extension

## Sketchup::Licensing::ExtensionLicense
_Sketchup/Licensing/ExtensionLicense.rb_ [SketchUp 2015]

The Sketchup::Licensing::ExtensionLicense class is used to store extension

- `#days_remaining` [SketchUp 2015] — The days_remaining method is used to get the number of days remaining until license expiration.
- `#error_description` [SketchUp 2015] — The error_description method is used to obtain error information in case of failure to acquire a license
- `#licensed?` [SketchUp 2015] — The licensed? method is used to decide whether the extension is licensed to run or not.
- `#state` [SketchUp 2015] — The state method returns a constant indicating the specific licensing state

## Sketchup::LineStyle < Sketchup::Entity
_Sketchup/LineStyle.rb_ [SketchUp 2019]

This provides a way for SketchUp to customize a line style and be set on a

- `#name` [SketchUp 2019] — The {#name} method retrieves the name of the line style object.

## Sketchup::LineStyles < Sketchup::Entity
_Sketchup/LineStyles.rb_ [SketchUp 2019]

Provides access to the different line style objects in the model.

- `#[](name)` [SketchUp 2019] — The {#[]} method lets you retrieve a line style by name or index
- `#[](name)` [SketchUp 2019] — The {#[]} method lets you retrieve a line style by name or index
- `#each` [SketchUp 2019] — The {#each} method is used to iterate through all the line styles.
- `#names` [SketchUp 2019] — The {#names} method return the support line styles as strings.
- `#size` [SketchUp 2019] — The {#size} method returns the number of line styles that SketchUp supports.
- `#to_a` [SketchUp 2019] — The {#to_a} method returns an array of all the line styles.

## Sketchup::LoadHandler
_Sketchup/LoadHandler.rb_ [SketchUp 6.0]

The main purpose of the +LoadHandler+ interface is to be used as an optional second parameter of

- `#cancelled?` — This method is called when the download is canceled by the user.
- `#onFailure(message)` — This method is called when the download unsuccessfully completes
- `#onPercentChange(percent)` — This method is triggered whenever the percent value updates.
- `#onSuccess` — This method is called when the download successfully completes

## Sketchup::Loop < Sketchup::Entity
_Sketchup/Loop.rb_ [SketchUp 6.0]

Loop is a low level topology class that will not need to be used often. A

- `#convex?` [SketchUp 6.0] — Determine if the loop is convex.
- `#edges` [SketchUp 6.0] — Get an array of the edges that define the loop in an ordered sequence.
- `#edgeuses` [SketchUp 6.0] — Get an array of the EdgeUse objects that define this loop in an ordered sequence.
- `#face` [SketchUp 6.0] — Get the Face object that is bounded by this loop.
- `#outer?` [SketchUp 6.0] — Determine if this is an outer loop
- `#vertices` [SketchUp 6.0] — Get an array of the vertices that define the loop in an ordered sequence.

## Sketchup::Material < Sketchup::Entity
_Sketchup/Material.rb_ [SketchUp 6.0]

The {Sketchup::Material} class represents a {Sketchup::Texture}

Constants: COLORIZE_SHIFT, COLORIZE_TINT, MATERIAL_COLORIZED_TEXTURED, MATERIAL_SOLID, MATERIAL_TEXTURED, NORMAL_STYLE_DIRECTX, NORMAL_STYLE_OPENGL, OWNER_IMAGE, OWNER_LAYER, OWNER_MANAGER, WORKFLOW_CLASSIC, WORKFLOW_PBR_METALLIC_ROUGHNESS

- `#<=>(material)` [SketchUp 6.0] — The {#<=>} method is used to compare two materials based on #{display_name}.
- `#==(material)` [SketchUp 6.0] — The {#==} method is used to test if two materials are the same.
- `#alpha` [SketchUp 6.0] — The {#alpha} method is used to get the opacity of the material
- `#alpha=(alpha)` [SketchUp 6.0] — The {#alpha=} method is used to set the opacity of the material
- `#ao_enabled=(enabled)` [SketchUp 2025.0.2] — 
- `#ao_enabled?` [SketchUp 2025.0] — 
- `#ao_strength` [SketchUp 2025.0] — 
- `#ao_strength=(strenght)` [SketchUp 2025.0] — 
- `#ao_texture` [SketchUp 2025.0] — 
- `#ao_texture=(image_path)` [SketchUp 2025.0] — 
- `#color` [SketchUp 6.0] — The {#color} method is used to retrieve the color of the material
- `#color=(color)` [SketchUp 6.0] — The {#color=} method is used to set the color of the material
- `#colorize_deltas` [SketchUp 2015] — The {#colorize_deltas} method retrieves the HLS delta for colorized materials.
- `#colorize_type` [SketchUp 2015] — The {#colorize_type} method retrieves the type of colorization of the material
- `#colorize_type=(type)` [SketchUp 2015] — The {#colorize_type=} method set the type of colorization of the material
- `#display_name` [SketchUp 6.0] — The {#display_name} method retrieves the name that is displayed within SketchUp for the material
- `#materialType` [SketchUp 6.0] — The {#materialType} method retrieves the type of the material
- `#metallic_factor` [SketchUp 2025.0] — 
- `#metallic_factor=(factor)` [SketchUp 2025.0] — 
- `#metallic_texture` [SketchUp 2025.0] — 
- `#metallic_texture=(image_path)` [SketchUp 2025.0] — 
- `#metalness_enabled=(enabled)` [SketchUp 2025.0] — 
- `#metalness_enabled?` [SketchUp 2025.0] — 
- `#name` [SketchUp 6.0] — The {#name} method retrieves the name of the material
- `#name=(str)` [SketchUp 8.0 M1] — The {#name=} method sets the name of the material.
- `#normal_enabled=(enabled)` [SketchUp 2025.0.2] — 
- `#normal_enabled?` [SketchUp 2025.0] — 
- `#normal_scale` [SketchUp 2025.0] — 
- `#normal_scale=(scale)` [SketchUp 2025.0] — 
- `#normal_style` [SketchUp 2025.0] — {Material Normal Styles}[#normal_style_summary]: - {NORMAL_STYLE_OPENGL} - {NORMAL_STYLE_DIRECTX}
- `#normal_style=(style)` [SketchUp 2025.0] — {Material Normal Styles}[#normal_style_summary]: - {NORMAL_STYLE_OPENGL} - {NORMAL_STYLE_DIRECTX}
- `#normal_texture` [SketchUp 2025.0] — 
- `#normal_texture=(image_path)` [SketchUp 2025.0] — 
- `#owner_type` [SketchUp 2019.2] — The {#owner_type} method is used to determine what owns the material
- `#roughness_enabled=(enabled)` [SketchUp 2025.0] — 
- `#roughness_enabled?` [SketchUp 2025.0] — 
- `#roughness_factor` [SketchUp 2025.0] — 
- `#roughness_factor=(factor)` [SketchUp 2025.0] — 
- `#roughness_texture` [SketchUp 2025.0] — 
- `#roughness_texture=(image_path)` [SketchUp 2025.0] — 
- `#save_as(filename)` [SketchUp 2017] — The {#save_as} method is used to write a material to a SKM file.
- `#texture` [SketchUp 6.0] — The {#texture} method retrieves the texture of the material.
- `#texture=(filename)` [SketchUp 2018] — The {#texture=} method sets the texture for the material
- `#use_alpha?` [SketchUp 6.0] — The {#use_alpha?} method tells if the material uses transparency
- `#workflow` [SketchUp 2025.0] — {Material Workflows}[#workflow_constant_summary]: - {WORKFLOW_CLASSIC} - {WORKFLOW_PBR_METALLIC_ROUGHNESS} When the workflow returns +WORKFLOW_PBR_MET
- `#write_thumbnail(path, max_size)` [SketchUp 8.0 M1] — The {#write_thumbnail} method writes a bitmap thumbnail to the given file name.

## Sketchup::Materials < Sketchup::Entity
_Sketchup/Materials.rb_ [SketchUp 6.0]

A collection of Materials objects. Each model contains a Materials collection

- `#[](index)` [SketchUp 6.0] — The {#[]} method is used to retrieve a material by index or name
- `#add(name)` [SketchUp 6.0] — Add a new Material
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the materials collection.
- `#[](index)` [SketchUp 6.0] — The {#[]} method is used to retrieve a material by index or name
- `#count` [SketchUp 6.0] — 
- `#current` [SketchUp 6.0] — The current method is used to get the current material, i.e
- `#current=(material)` [SketchUp 6.0] — The current= method is used to set the current material.
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through all of the materials.
- `#length` [SketchUp 6.0] — The number of materials in the collection.
- `#load(filename)` [SketchUp 2017] — The {#load} method is used to load a material from file into the model
- `#purge_unused` [SketchUp 6.0] — The purge_unused method is used to remove unused materials.
- `#remove(material)` [SketchUp 8.0 M1] — Remove a given material.
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the materials collection.
- `#size` [SketchUp 2014] — The number of materials in the collection
- `#unique_name(name)` [SketchUp 2018] — The {#unique_name} method is used to retrieve a unique name from the materials collection that is based on the provided one

## Sketchup::MaterialsObserver
_Sketchup/MaterialsObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to materials events.

- `#onMaterialAdd(materials, material)` [SketchUp 6.0] — The {#onMaterialAdd} method is invoked whenever a new material is added.
- `#onMaterialChange(materials, material)` [SketchUp 6.0] — The {#onMaterialChange} method is invoked whenever a material's texture image is altered.
- `#onMaterialRefChange(materials, material)` [SketchUp 6.0] — The {#onMaterialRefChange} method is invoked whenever the number of entities that a material is painted on changes
- `#onMaterialRemove(materials, material)` [SketchUp 6.0] — The {#onMaterialRemove} method is invoked whenever a material is deleted.
- `#onMaterialSetCurrent(materials, material)` [SketchUp 6.0] — The {#onMaterialSetCurrent} method is invoked whenever a different material is selected in the Materials dialog
- `#onMaterialUndoRedo(materials, material)` [SketchUp 6.0] — The {#onMaterialUndoRedo} method is invoked whenever a material is altered and then those changes are undone or redone.

## Sketchup::Menu
_Sketchup/Menu.rb_ [SketchUp 6.0]

An interface to a menu.

- `#add_item(title, &block)` [SketchUp 6.0] — The {#add_item} method is used to add a menu item to the specified menu
- `#add_separator` [SketchUp 6.0] — The {#add_separator} method is used to add a menu separator to a menu.
- `#add_submenu(title)` [SketchUp 6.0] — The {#add_submenu} method is used to add a sub-menu to a menu.
- `#set_validation_proc(item, &block)` [SketchUp 6.0] — The {#set_validation_proc} method is used to specify the menu validation procedure

## Sketchup::Model
_Sketchup/Model.rb_ [SketchUp 6.0]

This is the interface to a SketchUp model. The model is the 3D drawing that

Constants: LOAD_STATUS_SUCCESS, LOAD_STATUS_SUCCESS_MORE_RECENT, VERSION_2013, VERSION_2014, VERSION_2015, VERSION_2016, VERSION_2017, VERSION_2018, VERSION_2019, VERSION_2020, VERSION_2021, VERSION_3, VERSION_4, VERSION_5, VERSION_6, VERSION_7, VERSION_8

- `#abort_operation` [SketchUp 6.0] — The {#abort_operation} method aborts the current operation started with the start_operation method
- `#active_entities` [SketchUp 6.0] — Returns an {Sketchup::Entities} object which contains the entities in the open group or component instance
- `#active_layer` [SketchUp 6.0] — The {#active_layer} method retrieves the active Layer
- `#active_layer=(layer)` [SketchUp 6.0] — The {#active_layer=} method sets the active {Sketchup::Layer} object.
- `#active_path` [SketchUp 7.0] — Returns an array containing the sequence of entities the user has double-clicked on for editing
- `#active_path=(instance_path)` [SketchUp 2020.0] — The {#active_path=} method is used to open a given instance path for editing.
- `#active_section_planes` [SketchUp 2026.0] — The {#active_section_planes} method returns all of the active section planes in the model.
- `#active_view` [SketchUp 6.0] — The {#active_view} method returns the active View object for this model.
- `#add_note(note, x, y)` [SketchUp 6.0] — Add a text note to the Model
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#attribute_dictionaries` [SketchUp 6.0] — The {#attribute_dictionaries} method retrieves the AttributeDictionaries object that is associated with the Model.
- `#attribute_dictionary(name, create = false)` [SketchUp 6.0] — Returns the Sketchup::AttributeDictionary object that is specified by name
- `#axes` [SketchUp 2016] — The {#axes} method returns the drawing axes for the model.
- `#behavior` [SketchUp 6.0] — The behavior method retrieves the behavior of the model.
- `#bounds` [SketchUp 6.0] — The {#bounds} method is used to retrieve the {Geom::BoundingBox} bounding the contents of a {Sketchup::Model}.
- `#classifications` [SketchUp 2015] — The {#classifications} method is used to retrieve the Classifications object for this model.
- `#close(ignore_changes = false)` [SketchUp 2015] — The {#close} method is used to close this model
- `#close_active` [SketchUp 6.0] — The {#close_active} method is used to close the currently active (open) group or component.
- `#commit_operation` [SketchUp 6.0] — The commit_operation method commits an operation for undo
- `#definitions` [SketchUp 6.0] — The {#definitions} method retrieves a definition list containing all of the component definitions in the model.
- `#description` [SketchUp 6.0] — The description method retrieves a description of the model as found in the Model Info > Files panel
- `#description=(description)` [SketchUp 6.0] — The {#description=} method sets the description of the model.
- `#drawing_element_visible?(instance_path)` [SketchUp 2020.0] — The {#drawing_element_visible?} method reports whether the given drawing element in an instance path is visible given the current model options.
- `#edit_transform` [SketchUp 7.0] — Returns the transformation of the current component edit session
- `#entities` [SketchUp 6.0] — The {#entities} method returns an {Sketchup::Entities} object containing the entities in the root of model.
- `#environments` [SketchUp 2025.0] — The {#environments} method is used to retrieve the {Sketchup::Environments} object for this model.
- `#export(path, show_summary = false)` [SketchUp 6.0] — The export method is used to export a given file format
- `#find_entity_by_id(ids_or_array)` [SketchUp 2015] — Finds and returns entities by their entityID or GUID
- `#find_entity_by_persistent_id(ids_or_array)` [SketchUp 2020.2] — Finds and returns entities by their persistent id
- `#georeferenced?` [SketchUp 7.1] — This methods determines if the model is georeferenced.
- `#get_attribute(dictname, key, defaultvalue = nil)` [SketchUp 6.0] — The get_attribute method gets the value of an attribute that in the AttributeDictionary with the given name
- `#get_datum` [SketchUp 6.0] — the get_datum method retrieves the datum, in the form of a string, used in UTM conversions.
- `#get_product_family` [SketchUp 6.0] — Returns a value which indicates the product family of the installed SketchUp application
- `#guid` [SketchUp 6.0] — The guid method retrieves the globally unique identifier, in the form of a string, for the Model
- `#import(path, options)` [SketchUp 6.0] — The import method is used to load a file by recognizing the file extension and calling appropriate importer
- `#instance_path_from_pid_path(pid_path)` [SketchUp 2017] — The {#instance_path_from_pid_path} method returns a instance path given a string with persistent ids representing the path to the entity.
- `#latlong_to_point(lnglat_array)` [SketchUp 6.0] — The latlong_to_point method converts a latitude and longitude to a Point3d object in the model
- `#layers` [SketchUp 6.0] — The {#layers} method retrieves a collection of all {Sketchup::Layers} objects in the model.
- `#line_styles` [SketchUp 2019] — The {#line_styles} method returns the line styles manager.
- `#list_datums` [SketchUp 6.0] — This method retrieves an Array of all of the datums recognized by SketchUp.
- `#materials` [SketchUp 6.0] — The {#materials} method returns a collection of all of the materials in the model.
- `#mipmapping=(mipmap)` [SketchUp 7.0] — This method can be used to turn mipmapping on or off.
- `#mipmapping?` [SketchUp 7.0] — This method can be used to find out if mipmapping is on or off.
- `#modified?` [SketchUp 6.0] — The modified? method determines if the Model has been modified since the last save.
- `#name` [SketchUp 6.0] — The {#name} method retrieves the name of the model
- `#name=(name)` [SketchUp 6.0] — The {#name=} method sets the string name of the model.
- `#number_faces` [SketchUp 7.1] — Returns the number faces in a model.
- `#options` [SketchUp 6.0] — The {#options} method retrieves the options manager that defines the options settings for the model
- `#overlays` [SketchUp 2023.0] — 
- `#pages` [SketchUp 6.0] — The {#pages} method retrieves a {Sketchup::Pages} object containing all of the pages in the model.
- `#path` [SketchUp 6.0] — The path method retrieves the path of the file from which the model was opened
- `#place_component(componentdef, repeat = false)` [SketchUp 6.0] — The place_component method places a new component in the Model using the component placement tool.
- `#point_to_latlong(point)` [SketchUp 6.0] — The point_to_latlong method converts a point in the model to a LatLong so that you can get its latitude and longitude
- `#point_to_utm(point)` [SketchUp 6.0] — This method converts a Point3d object in the Model to UTM coordinates
- `#raytest(ray, wysiwyg_flag = true)` [SketchUp 6.0] — The {#raytest} method is used to cast a ray (line) through the model and return the first thing that the ray hits
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#rendering_options` [SketchUp 6.0] — The {#rendering_options} method retrieves the RenderingOptions object for this model.
- `#save` [SketchUp 2014] — This method is used to save the model to a file.
- `#save_copy(path)` [SketchUp 2014] — This method is used to save the copy of the current model to a file.
- `#save_thumbnail(filename)` [SketchUp 6.0] — The save_thumbnail method is used to save a thumbnail image to a file
- `#select_tool(tool)` [SketchUp 6.0] — The {#select_tool} method is used to select a SketchUp Tool object as the active tool
- `#selection` [SketchUp 6.0] — This method retrieves a Selection object for the model, containing the currently selected entities
- `#set_attribute(attrdictname, key, value)` [SketchUp 6.0] — This method is used to set the value of an attribute in an attribute dictionary with the given name
- `#set_datum(datum)` [SketchUp 6.0] — This method sets the datum used in conversions between the internal coordinate system and UTM
- `#shadow_info` [SketchUp 6.0] — This method is used to retrieve the shadow information for the Model.
- `#start_operation(op_name, disable_ui = false, next_transparent = false, transparent = false)` [SketchUp 6.0] — The {#start_operation} method is used to notify SketchUp that a new operation (which can be undone) is starting
- `#styles` [SketchUp 6.0] — The {#styles} method retrieves the styles associated with the model.
- `#tags` [SketchUp 6.0] — The tags method retrieves the string tags of the model.
- `#tags=(tags)` [SketchUp 6.0] — The tags= method sets the string tags of the model.
- `#title` [SketchUp 6.0] — The {#title} method retrieves the name of the model
- `#tools` [SketchUp 6.0] — The {#tools} method is used to retrieve the current {Sketchup::Tools} object.
- `#utm_to_point(utm)` [SketchUp 6.0] — The utm_to_point method converts a position given in UTM coordinates to a Point3d in the Model.
- `#valid?` [SketchUp 6.0] — Determine if a model is a valid Sketchup::Model object

## Sketchup::ModelObserver
_Sketchup/ModelObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to model events.

- `#onActivePathChanged(model)` — The {#onActivePathChanged} method is invoked when the user opens or closes a {Sketchup::ComponentInstance} or {Sketchup::Group} for editing
- `#onAfterComponentSaveAs(model)` [SketchUp 7.0] — The {#onAfterComponentSaveAs} method is invoked when the user context-clicks > Save As on a component instance
- `#onBeforeComponentSaveAs(model)` [SketchUp 7.0] — The {#onBeforeComponentSaveAs} method is invoked when the user context-clicks > Save As on a component instance
- `#onDeleteModel(model)` [SketchUp 6.0] — The {#onDeleteModel} method is invoked when a model is deleted.
- `#onEraseAll(model)` [SketchUp 6.0] — The {#onEraseAll} method is invoked when everything in a model is erased.
- `#onExplode(model)` [SketchUp 7.0] — The {#onExplode method} is invoked whenever a component anywhere in this model is exploded
- `#onPidChanged(model, old_pid, new_pid)` [SketchUp 2017] — The {#onPidChanged} method is invoked when a {Sketchup::Entity#persistent_id persistent id} of an entity changes within the model.
- `#onPlaceComponent(model)` [SketchUp 7.0] — The {#onPlaceComponent} method is invoked when a component is "placed" into the model, meaning it is dragged from the Component Browser.
- `#onPostSaveModel(model)` [SketchUp 8.0] — The {#onPostSaveModel} method is invoked after a model has been saved to disk.
- `#onPreSaveModel(model)` [SketchUp 8.0] — The {#onPreSaveModel} method is invoked before a model is saved to disk.
- `#onSaveModel(model)` [SketchUp 6.0] — The {#onSaveModel} method is invoked after a model has been saved to disk.
- `#onTransactionAbort(model)` [SketchUp 6.0] — The {#onTransactionAbort} method is invoked when a transaction is aborted.
- `#onTransactionCommit(model)` [SketchUp 6.0] — The {#onTransactionCommit} method is invoked when a transaction is completed.
- `#onTransactionEmpty(model)` [SketchUp 6.0] — The {#onTransactionEmpty} method is invoked when a transaction (aka an undoable operation) starts and then is committed without anything being altered
- `#onTransactionRedo(model)` [SketchUp 6.0] — The {#onTransactionRedo} method is invoked when the user "redoes" a transaction (aka undo operation.) You can programmatically fire a redo by calling 
- `#onTransactionStart(model)` [SketchUp 6.0] — The {#onTransactionStart} method is invoked when a transaction (aka an undoable operation) starts.
- `#onTransactionUndo(model)` [SketchUp 6.0] — The {#onTransactionUndo method} is invoked when the user "undoes" a transaction (aka undo operation.) You can programmatically fire an undo by calling

## Sketchup::OptionsManager
_Sketchup/OptionsManager.rb_ [SketchUp 6.0]

The OptionsManager class manages various kinds of OptionsProviders on a

- `#[](index)` [SketchUp 6.0] — The [] method is used to get an option provider by name or index
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through options providers.
- `#keys` [SketchUp 6.0] — The keys method is used to get a list of keys in the OptionsManager.
- `#length` [SketchUp 2014] — The {#length} method is an alias of {#size}.
- `#size` [SketchUp 6.0] — The {#size} method returns the number of {OptionsProvider} objects inside this {OptionsManager}.

## Sketchup::OptionsProvider
_Sketchup/OptionsProvider.rb_ [SketchUp 6.0]

An +OptionsProvider+ class provides various kinds of options on a

- `#[](index)` [SketchUp 6.0] — The [] method is used to get a value by name or index of the key.
- `#[]=(key, value)` [SketchUp 6.0] — The []= method is used to set the value of a specific key
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through all of the options.
- `#each_key` [SketchUp 6.0] — The {#each_key} method is used to iterate through all of the attribute keys.
- `#each_pair` [SketchUp 6.0] — The {#each} method is used to iterate through all of the options.
- `#each_value` [SketchUp 6.0] — The {#each_value} method is used to iterate through all of the attribute values.
- `#has_key?(name)` [SketchUp 6.0] — The {#has_key?} method is an alias for {#key?}.
- `#key?(name)` [SketchUp 6.0] — The {#key?} method is used to determine if the options provider has a specific key.
- `#keys` [SketchUp 6.0] — The {#keys} method is used to retrieve an array with all of the attribute keys.
- `#length` [SketchUp 2014] — The {#length} method is an alias of {#size}.
- `#name` [SketchUp 6.0] — The name method is used to retrieve the name of an options provider.
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#size` [SketchUp 6.0] — The {#size} method is used to retrieve the size (number of elements) of an options provider.

## Sketchup::OptionsProviderObserver
_Sketchup/OptionsProviderObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to operations provider

- `#onOptionsProviderChanged(provider, name)` [SketchUp 6.0] — The {#onOptionsProviderChanged} method is invoked when a property of an {Sketchup::OptionsProvider} changes.

## Sketchup::Overlay
_Sketchup/Overlay.rb_ [SketchUp 2023.0]

An Overlay provides contextual model information directly in the viewport.

- `#description` [SketchUp 2023.0] — This is a short user facing description of the overlay that will appear in the UI.
- `#description=(description)` [SketchUp 2023.0] — Sets a short user facing description of the overlay that will appear in the UI
- `#draw(view)` [SketchUp 2023.0] — 
- `#enabled=(enabled)` [SketchUp 2023.0] — 
- `#enabled?` [SketchUp 2023.0] — 
- `#getExtents` [SketchUp 2023.0] — In order to accurately draw things, SketchUp needs to know the extents of what it is drawing
- `#initialize(id, name, description: "")` [SketchUp 2023.0] — 
- `#name` [SketchUp 2023.0] — This is a user facing display name that will appear in the UI.
- `#onMouseEnter(flags, x, y, view)` [SketchUp 2023.0] — The {#onMouseEnter} method is called by SketchUp when the mouse enters the viewport.
- `#onMouseLeave(view)` [SketchUp 2023.0] — The {#onMouseLeave} method is called by SketchUp when the mouse enters the viewport.
- `#onMouseMove(flags, x, y, view)` [SketchUp 2023.0] — Try to make this method as efficient as possible because this method is called often.
- `#overlay_id` [SketchUp 2023.0] — 
- `#source` [SketchUp 2023.0] — Describes the source associated with the overlay
- `#start` [SketchUp 2023.0] — 
- `#stop` [SketchUp 2023.0] — 
- `#valid?` [SketchUp 2023.0] — Indicates whether the overlay is valid

## Sketchup::OverlaysManager
_Sketchup/OverlaysManager.rb_ [SketchUp 2023.0]

An overlay added to a model is invalidated once it's removed from the model.

- `#[](index)` [SketchUp 2023.0] — Instance Methods
- `#add(service)` [SketchUp 2023.0] — 
- `#each` [SketchUp 2023.0] — 
- `#remove(service)` [SketchUp 2023.0] — 
- `#size` [SketchUp 2023.0] — 

## Sketchup::Page < Sketchup::Entity
_Sketchup/Page.rb_ [SketchUp 6.0]

The Page class contains methods to extract information and modify the properties of

- `#active_section_planes` [SketchUp 2026.0] — The {#active_section_planes} method is used to retrieve the active section plane for the {Sketchup::Page}.
- `#axes` [SketchUp 2016] — The axes method returns the drawing axes for the page
- `#camera` [SketchUp 6.0] — The {#camera} method retrieves the camera for a particular page
- `#delay_time` [SketchUp 6.0] — The delay_time method retrieves the amount of time, in seconds, that a page will be displayed before transition to another page during a tour
- `#delay_time=(seconds)` [SketchUp 6.0] — The delay_time= method sets the amount of time, in seconds, that a page will be displayed before transitioning to another page during a tour
- `#description` [SketchUp 6.0] — The description method retrieves the description for a page as found in the Scenes manager dialog.
- `#description=(description)` [SketchUp 6.0] — The description method sets the description for a page as found in the Scenes manager dialog.
- `#environment` [SketchUp 2025.0] — The {#environment} method is used to retrieve the {Sketchup::Environment} for the scene.
- `#environment=(environment)` [SketchUp 2025.0] — The {#environment=} method is used to set the {Sketchup::Environment} for the scene.
- `#get_drawingelement_visibility(element)` [SketchUp 2020.0] — The {#get_drawingelement_visibility} method is used to get the visibility of a drawing element on a particular page.
- `#hidden_entities` [SketchUp 6.0] — The hidden_entities method retrieves all hidden entities within a page.
- `#include_in_animation=(include)` [SketchUp 2018] — The {#include_in_animation=} method controls whether the page should be included when exporting an animation from the model.
- `#include_in_animation?` [SketchUp 2018] — The {#include_in_animation?} method determines whether the page should be included when exporting an animation from the model.
- `#label` [SketchUp 6.0] — The label method retrieves the label for a page from the page tab.
- `#layer_folders` [SketchUp 2021.0] — The {#layer_folders} method retrieves the hidden layer folders associated with a page.
- `#layers` [SketchUp 6.0] — The {#layers} method retrieves layers that don't use their default visibility on this page.
- `#name` [SketchUp 6.0] — The name method retrieves the name for a page from the page tab.
- `#name=(name)` [SketchUp 6.0] — The {#name=} method sets the name for a page's tab
- `#rendering_options` [SketchUp 6.0] — The rendering_options method retrieves a RenderingOptions object for the page
- `#set_drawingelement_visibility(element, visibility)` [SketchUp 2020.0] — The {#set_drawingelement_visibility} method is used to change the visibility of a drawing element on a particular page
- `#set_visibility(layer, visible_for_page)` [SketchUp 2021.0] — The {#set_visibility} method sets the visibility for a layer or layer folder on a page.
- `#shadow_info` [SketchUp 6.0] — The {#shadow_info} method retrieves the ShadowInfo object for the page
- `#style` [SketchUp 6.0] — The style method retrieves the style associated with the page.
- `#transition_time` [SketchUp 6.0] — Get the amount of time that it takes to transition to this page during a slideshow or animation export
- `#transition_time=(trans_time)` [SketchUp 6.0] — The transition_time= method is used to set the transition time.
- `#update(flags)` [SketchUp 6.0] — The {#update} method performs an update on the page properties based on the current view that the user has
- `#use_axes=(pagesettings)` [SketchUp 6.0] — The use_axes= method sets the page's axes property.
- `#use_axes?` [SketchUp 6.0] — The use_axes? method determines whether you are storing the axes property with the page.
- `#use_camera=(setting)` [SketchUp 6.0] — The use_camera= method sets the page's camera property.
- `#use_camera?` [SketchUp 6.0] — The use_camera? method determines whether you are storing the camera property with the page.
- `#use_environment=(use_environment)` [SketchUp 2025.0] — The {#use_environment=} method is used to set if the {Sketchup::Environment} settings are used in the scene.
- `#use_environment?` [SketchUp 2025.0] — The {#use_environment?} method is used to determine if the {Sketchup::Environment} settings are used in the scene.
- `#use_hidden=(setting)` [SketchUp 6.0] **DEPRECATED** — The use_hidden= method sets the page's hidden property.
- `#use_hidden?` [SketchUp 6.0] **DEPRECATED** — The use_hidden? method determines whether you are storing the hidden property with the page.
- `#use_hidden_geometry=(setting)` [SketchUp 2020.1] — Sets the page's use hidden geometry property.
- `#use_hidden_geometry?` [SketchUp 2020.1] — Returns the use hidden geometry property from the page.
- `#use_hidden_layers=(setting)` [SketchUp 6.0] — The use_hidden_layers= method sets the page's hidden layers property.
- `#use_hidden_layers?` [SketchUp 6.0] — The use_hidden_layers? method determines whether you are storing the hidden layers property with the page.
- `#use_hidden_objects=(setting)` [SketchUp 2020.1] — Sets the page's use hidden objects property.
- `#use_hidden_objects?` [SketchUp 2020.1] — Returns the use hidden objects property from the page.
- `#use_rendering_options=(setting)` [SketchUp 6.0] — The use_rendering_optoins= method sets the page's display settings property.
- `#use_rendering_options?` [SketchUp 6.0] — The use_rendering_options? method determines whether you are storing the rendering options property with the page.
- `#use_section_planes=(setting)` [SketchUp 6.0] — The use_section_planes= method sets the page's section planes property.
- `#use_section_planes?` [SketchUp 6.0] — The use_section_planes? method determines whether you are storing the section planes property with the page.
- `#use_shadow_info=(setting)` [SketchUp 6.0] — The use_shadow_info= method sets the page's shadow info property.
- `#use_shadow_info?` [SketchUp 6.0] — The use_shadow_info? method determines whether you are storing the shadow info property with the page.
- `#use_style=(style)` [SketchUp 6.0] — The use_style= method sets the style to be used by the page.
- `#use_style?` [SketchUp 6.0] — The use_style? method determines whether storing a style with the page.

## Sketchup::Pages < Sketchup::Entity
_Sketchup/Pages.rb_ [SketchUp 6.0]

The Pages class contains methods for manipulating a collection of Pages

- `.add_frame_change_observer(object)` [SketchUp 6.0] — The {.add_frame_change_observer} method is used to add a new frame change observer that is called with each frame of an animation, meaning the end use
- `.remove_frame_change_observer(observer_id)` [SketchUp 6.0] — The {.remove_frame_change_observer} method is used to remove a frame change observer
- `#[](index_or_name)` [SketchUp 6.0] — The [] method retrieves a page by either name or index.
- `#add(name = nil, flags = PAGE_USE_ALL, index = self.size)` [SketchUp 6.0] — The {#add} method is used to add a new Page object to the collection
- `#add_matchphoto_page(image_filename, camera = nil, page_name = nil)` [SketchUp 7.0] — The {#add_matchphoto_page} method is used to add a photomatch page to the model
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the Pages object
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through pages in the model.
- `#erase(page)` [SketchUp 6.0] — The {#erase} method is used to remove a page from the collection.
- `#length` [SketchUp 2014] — The {#length} method is an alias for {#size}.
- `#parent` [SketchUp 6.0] — The parent method is used to determine the model for the Pages collection.
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object
- `#reorder(page, new_index)` [SketchUp 2025.0] — The {#reorder} method is used to reorder an existing {Sketchup::Page} object inside collection
- `#selected_page` [SketchUp 6.0] — The selected_page method is used to retrieve the currently selected page.
- `#selected_page=(page)` [SketchUp 6.0] — The selected_page method is used to set the currently selected page
- `#show_frame_at(seconds)` [SketchUp 6.0] — The {#show_frame_at} method is used to show a frame in animation (of the slide show) at a given time in seconds.
- `#size` [SketchUp 6.0] — The {#size} method is used to retrieve the number of pages.
- `#slideshow_time` [SketchUp 6.0] — The slideshow_time method is used to get the amount of time that a slideshow of all of the pages will take
- `#unique_name(base_name)` [SketchUp 2026.0] — The {#unique_name} method is used to generate a unique name for the page based on a base_name string

## Sketchup::PagesObserver < Sketchup::EntitiesObserver
_Sketchup/PagesObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to pages events.

- `#onContentsModified(pages)` [SketchUp 6.0] — The {#onContentsModified} method is invoked whenever the pages change.
- `#onElementAdded(pages, page)` [SketchUp 6.0] — The {#onElementAdded} method is invoked when an element is added to a {Sketchup::Pages} object.
- `#onElementRemoved(pages, page)` [SketchUp 6.0] — The {#onElementRemoved} method is invoked when an element is removed from a {Sketchup::Pages} object.

## Sketchup::PickHelper
_Sketchup/PickHelper.rb_ [SketchUp 6.0]

The {Sketchup::PickHelper} class is used to pick entities that reside under

Constants: PICK_CROSSING, PICK_INSIDE

- `#all_picked` [SketchUp 6.0] — The all_picked method is used to get an array of entities from the active entities from all the pick paths
- `#best_picked` [SketchUp 6.0] — The best_picked method is used to retrieve the "best" entity picked (entity that you would have picked if you were using the select tool)
- `#boundingbox_pick(bounding_box, pick_type, transformation = IDENTITY)` [SketchUp 2016] — Used to pick a set of entities from a model from a {Geom::BoundingBox}
- `#count` [SketchUp 6.0] — The count method is used to count the number of entities picked (number of pick records)
- `#depth_at(index)` [SketchUp 6.0] — The depth_at method retrieves the depth of one of the currently picked entities in the list of pick records.
- `#do_pick(x, y, aperture = 0)` [SketchUp 6.0] — The {#do_pick} method is used to perform the initial pick
- `#element_at(index)` [SketchUp 6.0] — The element_at method is used to retrieve a specific entity in the list of picked elements
- `#init(x, y, aperture = 0)` [SketchUp 6.0] — The {#init} method is used to initialize the PickHelper for testing points
- `#leaf_at(index)` [SketchUp 6.0] — The leaf_at method retrieves the deepest thing in a pick path
- `#path_at(index)` [SketchUp 6.0] — The path_at method is used to retrieve the entire path for an entity in the pick list (as an array)
- `#pick_segment(points)` [SketchUp 6.0] — The {#pick_segment} method is used to pick a segment of a polyline curve that is defined by an array of points
- `#picked_edge` [SketchUp 6.0] — The picked_edge method is used to retrieve the "best" Edge picked
- `#picked_element()` [SketchUp 6.0] — The picked_element method retrieves the best drawing element, that is not an edge or a face, picked
- `#picked_face` [SketchUp 6.0] — The picked_face method is used to retrieve the best face picked
- `#test_point(point)` [SketchUp 6.0] — The {#test_point} method is used to test a point to see if it would be selected using the default or given pick aperture
- `#transformation_at(index)` [SketchUp 6.0] — The transformation_at method is used to get a transformation at a specific pick path index in the pick helper
- `#view` [SketchUp 6.0] — The {#view} method is used to get the view associated with the {Sketchup::PickHelper}.
- `#window_pick(start_point, end_point, pick_type)` [SketchUp 2016] — Used to pick a set of entities from a model based on a screen coordinate rectangular area defined by two points

## Sketchup::RegionalSettings
_Sketchup/RegionalSettings.rb_ [SketchUp 2016 M1]

The {Sketchup::RegionalSettings} module contains methods getting information about the

- `.decimal_separator` [SketchUp 2016 M1] — Returns the decimal character for the current user's locale.
- `.list_separator` [SketchUp 2016 M1] — Returns the list separator character for the current user's locale.

## Sketchup::RenderingOptions < Sketchup::Entity
_Sketchup/RenderingOptions.rb_ [SketchUp 6.0]

The RenderingOptions class contains method to extract the rendering

- `.each_key` [SketchUp 6.0] — The {#each_key} method iterates through all of the rendering options keys.
- `.keys` [SketchUp 6.0] — The keys method returns an array with all of the attribute keys.
- `#[](key)` [SketchUp 6.0] — The {#[]} method is used to get the value of a rendering option.
- `#[]=(key, value)` [SketchUp 6.0] — The set value []= method is used to set the value in the array of rendering options.
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#count` [SketchUp 2014] — The {#count} method is inherited from the +Enumerable+ mix-in module.
- `#each` [SketchUp 6.0] — The {#each} method iterates through all of the rendering options key/value pairs.
- `#each_key` [SketchUp 6.0] — The {#each_key} method iterates through all of the rendering options keys.
- `#each_pair` [SketchUp 6.0] — The {#each_pair} method is an alias for {#each}.
- `#keys` [SketchUp 6.0] — The keys method returns an array with all of the attribute keys.
- `#length` [SketchUp 2014] — The {#length} method returns the number of options in the rendering options collection.
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#size` [SketchUp 2014] — The {#size} method is an alias for {#length}.

## Sketchup::RenderingOptionsObserver
_Sketchup/RenderingOptionsObserver.rb_ 

This observer interface is implemented to react to rendering options events.

- `#onRenderingOptionsChanged(rendering_options, type)` [SketchUp 6.0] — The onRenderingOptionsChanged method is invoked whenever the user changes their rendering options.

## Sketchup::SectionPlane < Sketchup::Drawingelement
_Sketchup/SectionPlane.rb_ [SketchUp 6.0]

The SectionPlane class represents a section plane in a SketchUp model. Note

- `#activate` [SketchUp 2014] — The activate method is used to make the section plane the active one of its parent component/group.
- `#active?` [SketchUp 2014] — The active? method indicates whether the section plane is active or not.
- `#get_plane` [SketchUp 6.0] — The get_plane method is used to retrieve the plane that the section plane is on.
- `#name` [SketchUp 2018] — The {#name} method is used to retrieve the name of the section plane.
- `#name=(name)` [SketchUp 2018] — The {#name=} method is used to set the name of a section plane.
- `#set_plane(plane)` [SketchUp 6.0] — The set_plane method is used to set the plane that the section plane is on.
- `#symbol` [SketchUp 2018] — The {#symbol} method is used to retrieve the symbol of the section plane.
- `#symbol=(symbol)` [SketchUp 2018] — The {#symbol=} method is used to set the symbol of a section plane.

## Sketchup::Selection
_Sketchup/Selection.rb_ [SketchUp 6.0]

A set of the currently selected drawing elements. Use the Model.selection method

- `#[](index)` [SketchUp 6.0] — The {#[]} method is used to retrieve a {Sketchup::Drawingelement} from the selection by index
- `#add(drawing_elements)` [SketchUp 6.0] — The {#add} method is used to add Drawingelement to the selection
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the selection object.
- `#at(index)` [SketchUp 6.0] — The {#at} method is an alias for {#[]}.
- `#clear` [SketchUp 6.0] — The clear method is used to clear the selection.
- `#contains?(drawing_element)` [SketchUp 6.0] — The {#contains?} method is and alias of {#include?}.
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through all of the selected Drawingelements
- `#empty?` [SketchUp 6.0] — The {#empty?} method is used to determine if there are drawing elements in the selection.
- `#first` [SketchUp 6.0] — The {#first} method is used to retrieve the first selected Drawingelement Returns nil if nothing is selected
- `#include?(drawing_element)` [SketchUp 6.0] — The {#include?} method is used to determine if a given {Sketchup::Drawingelement} is in the selection.
- `#invert` [SketchUp 2019.2] — The {#invert} method is used to invert the selection.
- `#is_curve?` [SketchUp 6.0] — The {#is_curve?} method is used to determine if the selection contains all edges that belong to a single curve.
- `#is_surface?` [SketchUp 6.0] — The {#is_surface?} method is used to determine if the selection contains only all of the faces that are part of a single curved surface.
- `#length` [SketchUp 6.0] — The {#length} method is used to retrieve the number of selected drawing elements.
- `#model` [SketchUp 6.0] — The {#model} method retrieves the model for the selection.
- `#nitems` [SketchUp 6.0] — The {#nitems} method is an alias for {#length}.
- `#remove(drawing_elements)` [SketchUp 6.0] — The {#remove} method is used to remove Drawingelements from the selection
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the selection object.
- `#shift` [SketchUp 6.0] — The {#shift} method is used to remove the first Drawingelement from the selection and returns it.
- `#single_object?` [SketchUp 6.0] — The {#single_object?} method is used to determine if the selection contains a single object
- `#size` [SketchUp 2014] — The {#size} method is an alias for {#length}.
- `#toggle(drawings_elements)` [SketchUp 6.0] — The {#toggle} method is used to change whether a Drawingelement is part of the selection

## Sketchup::SelectionObserver
_Sketchup/SelectionObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to selection events.

- `#onSelectionAdded(selection, entity)` [SketchUp 6.0] — Instance Methods
- `#onSelectionBulkChange(selection)` [SketchUp 6.0] — The {#onSelectionBulkChange} method is called whenever items are added or removed from the selection set
- `#onSelectionCleared(selection)` [SketchUp 6.0] — The {#onSelectionCleared} method is called when the selection is completely emptied.
- `#onSelectionRemoved(selection, entity)` [SketchUp 6.0] — 

## Sketchup::Set
_Sketchup/Set.rb_ [SketchUp 6.0]

The set class represents a collection of unique objects. This class is useful

- `#clear` [SketchUp 6.0] — The clear method is used to clear all objects out of the set.
- `#contains?(entity)` [SketchUp 6.0] — The {#contains?} method is an alias for {#include?}.
- `#delete(object)` [SketchUp 6.0] — The delete object is used to delete or remove an object from the set.
- `#each` [SketchUp 6.0] — The each method is used to iterate through all of the objects in the set.
- `#empty?` [SketchUp 6.0] — The empty? method is used to determine whether the set is empty.
- `#include?(entity)` [SketchUp 6.0] — The {#include?} method is used to determine if the set includes a particular object.
- `#insert(object)` [SketchUp 6.0] — The insert method is used to insert an object into the set.
- `#length` [SketchUp 6.0] — The {#length} method is an alias for {#size}.
- `#size` [SketchUp 6.0] — The {#size} method is used to determine the number of objects in the set.
- `#to_a` [SketchUp 6.0] — The to_a method is used to get an Array of the entities in your Set.

## Sketchup::ShadowInfo < Sketchup::Entity
_Sketchup/ShadowInfo.rb_ [SketchUp 6.0]

The {Sketchup::ShadowInfo} class contains method to extract the shadow

- `.each_key` [SketchUp 6.0] — The {#each_key} method iterates through all of the shadow information keys.
- `.keys` [SketchUp 6.0] — The keys method is a class method that returns an array with all of the attribute keys
- `#[](key)` [SketchUp 6.0] — The [] method retrieves a value from the array of keys
- `#[]=(key, value)` [SketchUp 6.0] — The set value []= method is used to set the value in the array of shadow info options
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#count` [SketchUp 2014] — The count method is inherited from the Enumerable mix-in module.
- `#each` [SketchUp 6.0] — The {#each} method iterates through all of the shadow information key/value pairs.
- `#each_key` [SketchUp 6.0] — The {#each_key} method iterates through all of the shadow information keys.
- `#each_pair` [SketchUp 6.0] — The {#each_pair} method is an alias for {#each}.
- `#keys` [SketchUp 6.0] — The keys method is a class method that returns an array with all of the attribute keys
- `#length` [SketchUp 2014] — The {#length} method returns the number of options in the shadow options collection
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#size` [SketchUp 2014] — The {#size} method is an alias for {#length}.

## Sketchup::ShadowInfoObserver
_Sketchup/ShadowInfoObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to changes to the shadow

- `#onShadowInfoChanged(shadow_info, type)` [SketchUp 6.0] — The {#onShadowInfoChanged} method is invoked whenever the user alters a setting inside the Shadows and Model Info dialogs

## Sketchup::Skp
_Sketchup/Skp.rb_ [SketchUp 2021.0]

The {Sketchup::Skp} module is used to read metadata from external SketchUp

- `.read_guid(filepath)` [SketchUp 2021.0] — The {.read_guid} method is used to read the GUID, globally unique identifier, for an external model

## Sketchup::Snap < Sketchup::Drawingelement
_Sketchup/Snap.rb_ [SketchUp 2025.0]

A Snap is a custom grip used by SketchUp's Move tool.

- `#direction` [SketchUp 2025.0] — The {#direction} method is used to get the direction this Snap is "pointing"
- `#position` [SketchUp 2025.0] — The {#position} method is used to get the position of this Snap.
- `#set(position)` [SketchUp 2025.0] — The {#set} method is used to move and/or reorient a Snap.
- `#up` [SketchUp 2025.0] — The {#up} method is used to get a vector representing the rotation of this Snap along its axis

## Sketchup::Style < Sketchup::Entity
_Sketchup/Style.rb_ [SketchUp 6.0]

The Style class contains methods for modifying information about a specific

- `#description` [SketchUp 6.0] — The {#description} method gets the description for a {Sketchup::Style}.
- `#description=(description)` [SketchUp 6.0] — The {#description=} method sets the description for a {Sketchup::Style}.
- `#name` [SketchUp 6.0] — The {#name} method gets the name for a {Sketchup::Style}.
- `#name=(name)` [SketchUp 6.0] — The {#name=} method sets the name for a {Sketchup::Style}.
- `#path` [SketchUp 2025.0] — The {#path} method gets the file path the {Sketchup::Style} was loaded from.

## Sketchup::Styles < Sketchup::Entity
_Sketchup/Styles.rb_ [SketchUp 6.0]

The Styles class contains methods for manipulating a collection of styles in

- `#[](name)` [SketchUp 6.0] — The {#[]} method is used to retrieves a style by either name or index.
- `#active_style` [SketchUp 6.0] — The {#active_style} method is used to retrieve the active style
- `#active_style_changed` [SketchUp 6.0] — The {#active_style_changed} method tells you if the active style has been edited by the user since it was last saved.
- `#add_style(filename, select)` [SketchUp 6.0] — The {#add_style} method is used to create and load a style from the given file.
- `#count` [SketchUp 6.0] — 
- `#each` [SketchUp 6.0] — The {#each} method is used to iterate through styles.
- `#length` [SketchUp 2014] — The {#length} method is an alias of {#size}.
- `#parent` [SketchUp 6.0] — The {#parent} method is used to return the model for the styles.
- `#purge_unused` [SketchUp 6.0] — The {#purge_unused} method is used to remove unused styles from the model.
- `#remove_style(style)` [SketchUp 2026.0] — The {#remove_style} method is used to remove a {Sketchup::Style} from the {Sketchup::Styles}.
- `#selected_style` [SketchUp 6.0] — The {#selected_style} method is used to retrieve the style currently selected in the Styles Browser.
- `#selected_style=(style)` [SketchUp 6.0] — The {#selected_style=} method is used to set the currently selected style.
- `#size` [SketchUp 6.0] — The {#size} method is used to retrieve the number of styles in the collection.
- `#update_selected_style` [SketchUp 6.0] — The {#update_selected_style} method commits the current style settings to the style selected in the Style Browser.

## Sketchup::Text < Sketchup::Drawingelement
_Sketchup/Text.rb_ [SketchUp 6.0]

The Text class contains method to manipulate a Text entity object.

- `#arrow_type` [SketchUp 6.0] — The arrow_type method retrieves the current arrow type used for the leader text
- `#arrow_type=(type)` [SketchUp 6.0] — The arrow_type= method sets the arrow type used for leader text
- `#attached_to` [SketchUp 2019] — The {#attached_to} method returns an array of the attached {Sketchup::InstancePath} object and the {Geom::Point3d}.
- `#attached_to=(path)` [SketchUp 2019] — The {#attached_to=} method will attach the {Sketchup::Text} to another {Sketchup::DrawingElement}.
- `#display_leader=(status)` [SketchUp 6.0] — The display_leader= method accepts true or false for whether to display the leader
- `#display_leader?` [SketchUp 6.0] — The display_leader? method returns the status of the leader.
- `#has_leader?` [SketchUp 6.0] — The has_leader method is used to determine if the Text object has a leader.
- `#leader_type` [SketchUp 6.0] — The {#leader_type} method retrieves the currently set leader type
- `#leader_type=(type)` [SketchUp 6.0] — The {#leader_type=} method sets the leader type
- `#line_weight` [SketchUp 6.0] — The line_weight method returns a line weight in number of pixels
- `#line_weight=(weight)` [SketchUp 6.0] — The line_weight= method sets the line weight in pixels
- `#point` [SketchUp 6.0] — The point method is used to get the point associated with the text.
- `#point=(point3d)` [SketchUp 6.0] — The point= method is used to set the point associated with the text.
- `#set_text(textstring)` [SketchUp 6.0] — The set_text method is used to set the text within a Text object without recording an Undo operation.
- `#text` [SketchUp 6.0] — The text method is used to retrieve the string version of a Text object.
- `#text=(textstring)` [SketchUp 6.0] — The text= method is used to set the string version of a Text object.
- `#vector` [SketchUp 6.0] — The vector method is used to get the vector associated with the text.
- `#vector=(vector)` [SketchUp 6.0] — The vector= method is used to set the vector associated with the text.

## Sketchup::Texture < Sketchup::Entity
_Sketchup/Texture.rb_ [SketchUp 6.0]

The Texture class contains methods for obtaining information about textures

- `#average_color` [SketchUp 6.0] — The average_color method retrieves a color object with the average color found in the texture.
- `#filename` [SketchUp 6.0] — The {#filename} method retrieves the full path, if available, for a texture object
- `#height` [SketchUp 6.0] — The height method is used to get the height of a repeatable texture image, in inches.
- `#image_height` [SketchUp 6.0] — The image_height method retrieves the height of the repeatable texture image, in pixels.
- `#image_rep(colorized = false)` [SketchUp 2018] — The {#image_rep} method returns a copy of a {Sketchup::ImageRep} object representing the texture pixel data.
- `#image_width` [SketchUp 6.0] — The image_width method retrieves the width of the repeatable texture image, in pixels.
- `#size=(size)` [SketchUp 6.0] — The size= method allows you to set the size of the repeatable texture image, in inches,
- `#valid?` [SketchUp 6.0] — The valid? method ensures that a texture is valid.
- `#width` [SketchUp 6.0] — The width method is used to get the width of a repeatable texture image, in inches.
- `#write(path, colorize = false)` [SketchUp 2016] — Writes the texture to file with option to preserve the color adjustments made by the material.

## Sketchup::TextureWriter
_Sketchup/TextureWriter.rb_ [SketchUp 6.0]

The TextureWriter class is used primarily for writing the textures used in a

- `#count` [SketchUp 6.0] — The {#length} method is used to determine the number of textures loaded into the texture writer
- `#filename(handle)` [SketchUp 6.0] — The filename method is used to retrieve the original filename for a particular texture.
- `#handle(entity)` [SketchUp 6.0] — The handle method is used to retrieve a handle or index for a specific texture in the texture writer.
- `#length` [SketchUp 6.0] — The {#length} method is used to determine the number of textures loaded into the texture writer
- `#load(entity)` [SketchUp 6.0] — The load method is used to load one or more textures into the texture writer for writing out to a file.
- `#write(entity, filename)` [SketchUp 6.0] — The write method is used to write an individual textures, within the texture writer, to a file
- `#write_all(dirname, filename_format)` [SketchUp 6.0] — The write_all method is used to write all of the textures within the texture writer to files

## Sketchup::Tool
_Sketchup/Tool.rb_ [SketchUp 6.0]

Tool is the interface that you implement to create a SketchUp tool.

- `#activate` [SketchUp 6.0] — The {#activate} method is called by SketchUp when the tool is selected
- `#deactivate(view)` [SketchUp 6.0] — The {#deactivate} method is called when the tool is deactivated because a different tool was selected.
- `#draw(view)` [SketchUp 6.0] — The {#draw} method is called by SketchUp whenever the view is refreshed to allow the tool to do its own drawing
- `#enableVCB?` [SketchUp 6.0] — The {#enableVCB?} method is used to tell SketchUp whether to allow the user to enter text into the VCB (value control box, aka the "measurements" pane
- `#getExtents` [SketchUp 6.0] — In order to accurately draw things, SketchUp needs to know the extents of what it is drawing
- `#getInstructorContentDirectory` [SketchUp 6.0] — The {#getInstructorContentDirectory} method is used to tell SketchUp the directory containing your Tool's instructor content
- `#getMenu(menu)` [SketchUp 2015] — The {#getMenu} method is called by SketchUp to let the tool provide its own context menu
- `#onCancel(reason, view)` [SketchUp 6.0] — The {#onCancel} method is called by SketchUp to cancel the current operation of the tool
- `#onKeyDown(key, repeat, flags, view)` [SketchUp 6.0] — The {#onKeyDown} method is called by SketchUp when the user presses a key on the keyboard
- `#onKeyUp(key, repeat, flags, view)` [SketchUp 6.0] — The {#onKeyUp} method is called by SketchUp when the user releases a key on the keyboard.
- `#onLButtonDoubleClick(flags, x, y, view)` [SketchUp 6.0] — The {#onLButtonDoubleClick} is called by SketchUp when the user double clicks with the left mouse button.
- `#onLButtonDown(flags, x, y, view)` [SketchUp 6.0] — The {#onLButtonDown} method is called by SketchUp when the left mouse button is pressed
- `#onLButtonUp(flags, x, y, view)` [SketchUp 6.0] — The {#onLButtonUp} method is called by SketchUp when the left mouse button is released.
- `#onMButtonDoubleClick(flags, x, y, view)` [SketchUp 6.0] — The {#onMButtonDoubleClick} method is called by SketchUp when the middle mouse button (on a three button mouse) is double-clicked
- `#onMButtonDown(flags, x, y, view)` [SketchUp 6.0] — The {#onMButtonDown} method is called by SketchUp when the middle mouse button (on a three button mouse) is down
- `#onMButtonUp(flags, x, y, view)` [SketchUp 6.0] — The {#onMButtonUp} method is called by SketchUp when the middle mouse button (on a three button mouse) is released
- `#onMouseEnter(view)` [SketchUp 6.0] — The {#onMouseEnter} method is called by SketchUp when the mouse enters the viewport.
- `#onMouseLeave(view)` [SketchUp 6.0] — The {#onMouseLeave} method is called by SketchUp when the mouse leaves the viewport.
- `#onMouseMove(flags, x, y, view)` [SketchUp 6.0] — The {#onMouseMove} method is called by SketchUp whenever the mouse is moved
- `#onMouseWheel(flags, delta, x, y, view)` [SketchUp 2019.2] — The {#onMouseWheel} method is called by SketchUp when the mouse scroll wheel is used.
- `#onRButtonDoubleClick(flags, x, y, view)` [SketchUp 6.0] — The {#onRButtonDoubleClick} is called by SketchUp when the user double clicks with the right mouse button.
- `#onRButtonDown(flags, x, y, view)` [SketchUp 6.0] — The {#onRButtonDown} method is called by SketchUp when the user presses the right mouse button
- `#onRButtonUp(flags, x, y, view)` [SketchUp 6.0] — The {#onRButtonUp} method is called by SketchUp when the user releases the right mouse button.
- `#onReturn(view)` [SketchUp 6.0] — The {#onReturn} method is called by SketchUp when the user hit the Return key to complete an operation in the tool
- `#onSetCursor` [SketchUp 6.0] — The {#onSetCursor} method is called by SketchUp when the tool wants to set the cursor.
- `#onUserText(text, view)` [SketchUp 6.0] — The {#onUserText} method is called by SketchUp when the user has typed text into the VCB and hit return.
- `#resume(view)` [SketchUp 6.0] — The {#resume} method is called by SketchUp when the tool becomes active again after being suspended.
- `#suspend(view)` [SketchUp 6.0] — The {#suspend} method is called by SketchUp when the tool temporarily becomes inactive because another tool has been activated

## Sketchup::Tools
_Sketchup/Tools.rb_ [SketchUp 6.0]

The Tools class contains methods to manipulate a collection of SketchUp

- `#active_tool` [SketchUp 2019] — The {#active_tool} method is used to obtain the active Ruby tool.
- `#active_tool_id` [SketchUp 6.0] — The active_tool_id method is used to retrieve the active tool's id.
- `#active_tool_name` [SketchUp 6.0] — The active_tool_name method is used to retrieve the active tool's name.
- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#model` [SketchUp 6.0] — The model method is used to get the model associated with this tools object.
- `#pop_tool` [SketchUp 6.0] — The pop_tool method is used to pop the last pushed tool on the tool stack.
- `#push_tool(tool)` [SketchUp 6.0] — The push_tool method is used to push (aka activate) a user-defined tool
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.

## Sketchup::ToolsObserver
_Sketchup/ToolsObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to tool events.

- `#onActiveToolChanged(tools, tool_name, tool_id)` [SketchUp 6.0] — Once you subclass {Sketchup::ToolsObserver} with your unique class, you can override the {#onActiveToolChanged} method to receive tool change notifica
- `#onToolStateChanged(tools, tool_name, tool_id, tool_state)` [SketchUp 6.0] — The {#onToolStateChanged} method is called each time the user performs an action with a tool

## Sketchup::UVHelper
_Sketchup/UVHelper.rb_ [SketchUp 6.0]

The UV Helper class contains methods allowing you to determine the location

- `#get_back_UVQ(point)` [SketchUp 6.0] — The {#get_back_UVQ} method is used to get the UV texture coordinates on the back of a face.
- `#get_front_UVQ(point)` [SketchUp 6.0] — The {#get_front_UVQ} method is used to get the UV texture coordinates on the front of a face.

## Sketchup::Vertex < Sketchup::Entity
_Sketchup/Vertex.rb_ [SketchUp 6.0]

A Vertex. A Vertex represents the end of an Edge or a point inside a Face.

- `#common_edge(vertex2)` [SketchUp 6.0] — The common_edge method is used to find a common edge that is defined by this vertex and another vertex
- `#curve_interior?` [SketchUp 6.0] — The {#curve_interior?} method is used to determine if this vertex is on the interior of a Curve.
- `#edges` [SketchUp 6.0] — The edges method is used to retrieve an Array of edges that use the Vertex.
- `#faces` [SketchUp 6.0] — The faces method is used to retrieve an Array of faces that use the vertex.
- `#loops` [SketchUp 6.0] — The loops method is used to retrieve an Array of loops that use the vertex.
- `#position` [SketchUp 6.0] — The position method is used to retrieve the Point3d position of a vertex.
- `#used_by?(face_or_edge)` [SketchUp 6.0] — The used_by? method is used to determine if the Vertex is used by a given Edge or Face.

## Sketchup::View
_Sketchup/View.rb_ [SketchUp 6.0]

This class contains methods to manipulate the current point of view of the

Constants: CORNER_BOTTOM_LEFT, CORNER_BOTTOM_RIGHT, CORNER_TOP_LEFT, CORNER_TOP_RIGHT

- `#add_observer(observer)` [SketchUp 6.0] — The add_observer method is used to add an observer to the current object.
- `#animation=(animation)` [SketchUp 6.0] — The {#animation=} method is used to set an animation that is displayed for a view
- `#average_refresh_time` [SketchUp 6.0] — The average_refresh_time is used to set the average time used to refresh the current model in the view
- `#camera` [SketchUp 6.0] — The camera method is used to retrieve the camera for the view.
- `#camera=(camera)` [SketchUp 6.0] — The {#camera=} method is used to set the camera for the view
- `#center()` [SketchUp 6.0] — The {#center} method is used to retrieve the coordinates of the center of the view in pixels.
- `#corner(index)` [SketchUp 6.0] — The {#corner} method is used to retrieve the coordinates of one of the corners of the view
- `#device_height` [SketchUp 2025.0] — The {#device_height} method is used to retrieve the height of the viewport for the view in physical pixels.
- `#device_width` [SketchUp 2025.0] — The {#device_width} method is used to retrieve the width of the viewport for the view in physical pixels.
- `#draw(openglenum, points)` [SketchUp 2020.0] — The {#draw} method is used to do basic drawing
- `#draw2d(openglenum, points)` [SketchUp 2020.0] — The {#draw2d} method is used to draw in screen space (using 2D screen coordinates) instead of 3D space
- `#draw_lines(points, ...)` [SketchUp 6.0] — The draw_lines method is used to draw disconnected lines
- `#draw_lines(points, ...)` [SketchUp 6.0] — The draw_lines method is used to draw disconnected lines
- `#draw_points(points, size = 6, style = 3, color = 'black')` [SketchUp 6.0] — This method is used to draw points in model space.
- `#draw_polyline(points, ...)` [SketchUp 6.0] — The draw_polyline method is used to draw a series of connected line segments from pt1 to pt2 to pt3, and so on
- `#draw_text(point, text)` [SketchUp 2016] — This method is used to draw text on the screen and is usually invoked within the draw method of a tool
- `#drawing_color=(color)` [SketchUp 6.0] — The drawing_color method is used to set the color that is used for drawing to the view
- `#dynamic=(value)` [SketchUp 6.0] **DEPRECATED** — The dynamic= method allows you to degrade visual quality while improving performance when a model is large and view refresh time is slow
- `#field_of_view` [SketchUp 6.0] — The field_of_view method is used get the view's field of view setting, in degrees.
- `#field_of_view=(fov)` [SketchUp 6.0] — The field_of_view= method is used set the view's field of view setting, in degrees.
- `#graphics_engine` [SketchUp 2024.0] — The {#graphics_engine} method is used query the type of the graphics engine that's currently used by this view.
- `#guess_target` [SketchUp 6.0] — The guess_target method is used to guess at what the user is looking at when you have a perspective view.
- `#inference_locked?` [SketchUp 6.0] — The inference_locked? method is used to determine if inference locking is on for the view.
- `#inputpoint(x, y)` [SketchUp 6.0] — The {#inputpoint} method is used to retrieve an {Sketchup::InputPoint}
- `#invalidate` [SketchUp 6.0] — The invalidate method is used mark the view as in need of a redraw.
- `#last_refresh_time` [SketchUp 6.0] — The last_refresh_time method is used to retrieve the time for the last full view refresh.
- `#line_stipple=(pattern)` [SketchUp 6.0] — The line_stipple= method is used to set the line pattern to use for drawing
- `#line_width=(width)` [SketchUp 6.0] — The line_width= method is used to set the line width to use for drawing
- `#load_texture(image_rep)` [SketchUp 2020.0] — Loads a texture to be drawn with {#draw} or {#draw2d}.
- `#lock_inference` [SketchUp 6.0] — The {#lock_inference} method is used to lock or unlock an inference
- `#model` [SketchUp 6.0] — The model method is used to retrieve the model for the current view.
- `#pick_helper` [SketchUp 6.0] — The {#pick_helper} method is used to retrieve a pick helper for the view.
- `#pickray(screen_point)` [SketchUp 6.0] — The {#pickray} method is used to retrieve a ray passing through a given screen position in the viewing direction.
- `#pixels_to_model(pixels, point)` [SketchUp 6.0] — The {#pixels_to_model} method is used to compute a model size from a pixel size at a given point
- `#refresh` [SketchUp 7.1] — The refresh method is used to immediately force a redraw of the view.
- `#release_texture(texture_id)` — Releases a texture loaded via {#load_texture}, freeing up it's memory
- `#remove_observer(observer)` [SketchUp 6.0] — The remove_observer method is used to remove an observer from the current object.
- `#screen_coords(model_point)` [SketchUp 6.0] — The {#screen_coords} method is used to retrieve the screen coordinates of the given point on the screen
- `#set_color_from_line(point1, point2)` [SketchUp 6.0] — Set the drawing color for the view based on the direction of a line that you want to draw
- `#show_frame(delay)` [SketchUp 6.0] — The show_frame method is used to show a frame of an Animation object in the current view
- `#text_bounds(point, text, options = {})` [SketchUp 2020.0] — This method is used to compute the bounds of the text when using {#draw_text}
- `#tooltip=(string)` [SketchUp 6.0] — Set a tooltip to display in the view
- `#vpheight` [SketchUp 6.0] — The {#vpheight} method is used to retrieve the height of the viewport for the view.
- `#vpwidth` [SketchUp 6.0] — The {#vpwidth} method is used to retrieve the width of the viewport for the view.
- `#write_image(filename, width = view.vpwidth, height = view.vpheight, antialias = false, compression = 1.0)` [SketchUp 7] — The {#write_image} method is used to write the current view to an image file
- `#zoom(zoom_or_ents)` [SketchUp 6.0] — The zoom method is used to zoom in or out by some zoom factor.
- `#zoom_extents` [SketchUp 6.0] — The zoom_extents method is used to zoom to the extents about the entire model, as if the user has selected the zoom extents command from the menu.

## Sketchup::ViewObserver
_Sketchup/ViewObserver.rb_ [SketchUp 6.0]

This observer interface is implemented to react to {Sketchup::View} events.

- `#onScaleFactorChange(view)` [SketchUp 2025.0] — The {#onScaleFactorChange} method is called whenever the view DPI of the view changes
- `#onViewChanged(view)` [SketchUp 6.0] — The {#onViewChanged} method is called whenever the view is altered, such as when the user uses the Pan, Orbit, or Zoom tools.

## SketchupExtension
_SketchupExtension.rb_ [SketchUp 6.0]

The SketchupExtension class contains methods allowing you to create and

- `#check` [SketchUp 8.0 M2] — Loads the extension, meaning the underlying ruby script is immediately interpreted
- `#copyright` [SketchUp 6.0] — The copyright method returns the copyright string which appears beneath an extension inside the Extensions Manager dialog.
- `#copyright=(copyright)` [SketchUp 6.0] — The copyright= method sets the copyright string which appears beneath an extension inside the Extensions Manager dialog.
- `#creator` [SketchUp 6.0] — The creator method returns the creator string which appears beneath an extension inside the Extensions Manager dialog.
- `#creator=(creator)` [SketchUp 6.0] — The creator= method sets the creator string which appears beneath an extension inside the Extensions Manager dialog.
- `#description` [SketchUp 6.0] — The description method returns the long description which appears beneath an extension inside the Extensions Manager dialog.
- `#description=(description)` [SketchUp 6.0] — The description= method sets the long description which appears beneath an extension inside the Extensions Manager dialog.
- `#extension_path` [SketchUp 2013] — The extension_path method returns the file system path to the extension's outer rb file.
- `#id` [SketchUp 2013] — The id method returns the Extension Warehouse ID string.
- `#initialize(title, path)` [SketchUp 6.0] — The new method is used to create a new SketchupExtension object
- `#load_on_start?` [SketchUp 8.0 M2] — Returns whether the extension is set to load when SketchUp starts up.
- `#loaded?` [SketchUp 8.0 M2] — Returns whether the extension is currently loaded, meaning the actual ruby script that implements the extension has been evaluated.
- `#name` [SketchUp 6.0] — The name method returns the name which appears for an extension inside the Extensions Manager dialog.
- `#name=(name)` [SketchUp 6.0] — The name= method sets the name which appears for an extension inside the Extensions Manager dialog.
- `#registered?` [SketchUp 8.0 M2] — Returns whether the extension has been registered via Sketchup.register_extension.
- `#uncheck` [SketchUp 8.0 M2] — Unloads the extension
- `#version` [SketchUp 6.0] — The version method returns the version which appears beneath an extension inside the Extensions Manager dialog.
- `#version=(version)` [SketchUp 6.0] — The version method sets the version which appears beneath an extension inside the Extensions Manager dialog.
- `#version_id` [SketchUp 2013] — The version_id method returns the Extension Warehouse Version ID string.

## String
_String.rb_ [SketchUp 6.0]

The String class contains a method used to parse a string as a length value.

- `#to_l` [SketchUp 6.0] — The to_l method is used to convert a string to a length

## UI
_UI.rb_ [SketchUp 6.0]

The UI module contains a number of methods for creating simple UI elements

- `.add_context_menu_handler` [SketchUp 6.0] — The add_context_menu_handler method is used to register a block of code with SketchUp that will be called when a context menu is to be displayed
- `.beep` [SketchUp 6.0] — The beep method plays a system beep sound
- `.create_cursor(path, hot_x, hot_y)` [SketchUp 6.0] — The {.create_cursor} method is used to create a cursor from an image file at the specified location
- `.get_clipboard_data` [SketchUp 2023.1] — Returns the plain text available on the clipboard, if there is any.
- `.inputbox(prompts, defaults, title)` [SketchUp 6.0] — Creates a dialog box for inputting user information
- `.inspector_names` [SketchUp 6.0] — The {.inspector_names} method is used to returns the names of all the inspectors
- `.menu(menu_name = "Extensions")` [SketchUp 6.0] — The {.menu} method retrieves a SketchUp's menu object with a given name
- `.messagebox(message, type = MB_OK)` [SketchUp 6.0] — Creates a dialog box containing static text with a series of buttons for the user to choose from
- `.model_info_pages` [SketchUp 6.0] — The model_info_pages method is used to returns the names of all the available model info pages
- `.openURL(url)` [SketchUp 6.0] — The {.openURL} method is used to open the default browser to a URL.
- `.openpanel(title, directory, filename)` [SketchUp 6.0] — The {.openpanel} method is used to display the Open dialog box
- `.play_sound(filename)` [SketchUp 6.0] — The play_sound method is used to play a sound file
- `.preferences_pages` [SketchUp 6.0] — The preferences_pages method is used to returns the names of all the preferences pages
- `.refresh_inspectors` [SketchUp 7.0] — Tells SketchUp to refresh all inspectors such as the Component Browser and the Outliner
- `.refresh_toolbars` [SketchUp 2018] — Tells SketchUp to refresh all floating toolbars
- `.savepanel(title, directory, filename)` [SketchUp 6.0] — The {.savepanel} method is used to display the Save dialog box
- `.scale_factor` [SketchUp 2017] **DEPRECATED** — Returns the scaling factor SketchUp uses on high DPI monitors
- `.select_directory(options = {})` [SketchUp 2015] — The {.select_directory} method is used to display the OS dialog for selecting one or several directories from the file system.
- `.set_clipboard_data(data)` [SketchUp 2023.1] — Copies plain text to the clipboard.
- `.set_cursor(cursor_id)` [SketchUp 6.0] — The {.set_cursor} method is used to change the cursor to a new cursor with a given cursor id
- `.set_toolbar_visible(name, visible)` [SketchUp 6.0] — The set_toolbar_visible method is used to set whether a given toolbar is visible
- `.show_extension_manager` [SketchUp 2017] — The +show_extension_manager+ method is used to display the Extension Manager dialog.
- `.show_extension_warehouse(extension_id = nil)` [SketchUp 2026.1] — Show the Extension Warehouse dialog inside SketchUp
- `.show_inspector(name)` [SketchUp 6.0] — The {.show_inspector} method is used to display the inspector with the given name
- `.show_model_info(page_name)` [SketchUp 6.0] — The {.show_model_info} method is used to display the model info dialog for a specific page
- `.show_preferences(page_name)` [SketchUp 6.0] — The show_preferences method is used to display a SketchUp preferences dialog
- `.start_timer(seconds, repeat = false)` [SketchUp 6.0] — The start_timer method is used to start a timer
- `.stop_timer(id)` [SketchUp 6.0] — The stop_timer method is used to stop a timer based on its id.
- `.toolbar(name)` [SketchUp 6.0] — The toolbar method is used to get a Ruby toolbar by name
- `.toolbar_names` [SketchUp 6.0] — The toolbar_names method is used to return the name of all the available native toolbars (this differs between PC and Mac)
- `.toolbar_visible?(name)` [SketchUp 6.0] — The toolbar_visible? method is used to determine whether a given toolbar is visible

## UI::Command
_UI/Command.rb_ [SketchUp 6.0]

The Command class is the preferred class for adding tools to the menus and

- `#extension` [SketchUp 2022.0] — The {#extension} method returns the command's associated extension.
- `#extension=(extension)` [SketchUp 2022.0] — The {#extension=} method explicitly sets the command's associated extension.
- `#get_validation_proc` [SketchUp 2022.0] — The {#get_validation_proc} method returns the command's validation proc.
- `#initialize(menutext)` [SketchUp 6.0] — The new method is used to create a new command.
- `#large_icon` [SketchUp 8.0 M1] — The large_icon method returns the icon file for the command's large icon.
- `#large_icon=(path)` [SketchUp 6.0] — The large_icon= method is used to identify the icon file for the command's large icon
- `#menu_text` [SketchUp 8.0 M1] — The menu_text method returns the menu item name for the command.
- `#menu_text=(menuitem)` [SketchUp 6.0] — The menu_text= method is used to set the menu item name for the command.
- `#proc` [SketchUp 2022.0] — The {#proc} method returns the command's proc that is called when the command is invoked.
- `#set_validation_proc` [SketchUp 6.0] — The {#set_validation_proc} method allows you to change whether the command is enabled, checked, etc
- `#small_icon` [SketchUp 8.0 M1] — The small_icon method returns the icon file for the command's small icon.
- `#small_icon=(path)` [SketchUp 6.0] — The small_icon= method is used to identify the icon file for the command's small icon
- `#status_bar_text` [SketchUp 8.0 M1] — The status_bar_text method returns the status bar text for the command.
- `#status_bar_text=(text)` [SketchUp 6.0] — The status_bar_text= method is used to set the status bar text for the command
- `#tooltip` [SketchUp 8.0 M1] — The tooltip method returns command item's tooltip text.
- `#tooltip=(text)` [SketchUp 6.0] — The {#tooltip=} method is used to define a command item's tooltip header

## UI::HtmlDialog
_UI/HtmlDialog.rb_ [SketchUp 2017]

The Ruby HtmlDialog class allows you to create and interact with HTML dialog

Constants: CEF_VERSION, CHROME_VERSION, STYLE_DIALOG, STYLE_UTILITY, STYLE_WINDOW

- `#add_action_callback(callback_name)` [SketchUp 2017] — The {#add_action_callback} method establishes a Ruby callback method that your html dialog can call to perform some function
- `#bring_to_front` [SketchUp 2017] — The {#bring_to_front} method is used to bring the window to the front, putting it on top of other windows even if its minimized.
- `#center` [SketchUp 2017] — The {#center} method is used to center the HtmlDialog relative to the active model window
- `#close` [SketchUp 2017] — The {#close} method is used to close a dialog box.
- `#execute_script(script)` [SketchUp 2017] — The {#execute_script} method is used to execute a JavaScript string on the html dialog asynchronously.
- `#get_content_size` [SketchUp 2021.1] — The {#get_content_size} method is used to get the content size of the HtmlDialog, in logical pixels.
- `#get_position` [SketchUp 2021.1] — The {#get_position} method is used to get the position of the HtmlDialog relative to the screen, in logical pixels.
- `#get_size` [SketchUp 2021.1] — The {#get_size} method is used to get the outer frame size of the HtmlDialog, in logical pixels.
- `#hide` [SketchUp 2026.1] — The {#hide} method is used to hide a dialog box without closing it
- `#initialize(properties)` [SketchUp 2017] — The new method is used to create a new HtmlDialog
- `#set_can_close` [SketchUp 2017] — The {#set_can_close} method is used to attach a block that is executed just before closing, this block has to return a boolean, if the block returns f
- `#set_content_size(width, height)` [SketchUp 2021.1] — The {#set_content_size} method is used to set the content size of the HtmlDialog, in logical pixels.
- `#set_file(filename)` [SketchUp 2017] — The {#set_file} method is used to identify a local HTML file to display in the HtmlDialog.
- `#set_html(html_string)` [SketchUp 2017] — The {#set_html} method is used to load a HtmlDialog with a string of provided HTML.
- `#set_on_closed` [SketchUp 2017] — The {#set_on_closed} method is used to attach a block that will be executed when a dialog is already in the process of closing, do any last minute ope
- `#set_position(left, top)` [SketchUp 2017] — The {#set_position} method is used to set the position of the HtmlDialog relative to the screen, in pixels.
- `#set_size(width, height)` [SketchUp 2017] — The {#set_size} method is used to set the outer frame size of the HtmlDialog, in pixels.
- `#set_url(url)` [SketchUp 2017] — The {#set_url} method is used to load a HtmlDialog with the content at a specific URL
- `#show` [SketchUp 2017] — The {#show} method is used to display a non-modal dialog box.
- `#show_modal` [SketchUp 2017] — The {#show_modal} method is used to display a modal dialog box.
- `#visible?` [SketchUp 2017] — The {#visible?} method is useful to tell if the dialog is shown and still alive, if the dialog is minimized or not visible on the screen this will sti

## UI::Notification
_UI/Notification.rb_ [SketchUp 2017]

{UI::Notification} objects allows you to show native notifications in the

- `#icon_name` [SketchUp 2017] — Gets the icon name, this is the path that will be used to get the icon from the file system path.
- `#icon_name=(icon_name)` [SketchUp 2017] — Sets the icon path, this icon will be loaded from the path give, the path has to be a local filesystem path.
- `#icon_tooltip` [SketchUp 2017] — Gets the icon Tooltip, this is the string that appear when the mouse is over the icon.
- `#icon_tooltip=(icon_tooltip)` [SketchUp 2017] — Sets the icon Tooltip, this string will appear when the mouse is over the icon.
- `#initialize(sketchup_extension, message = nil, icon_name = nil, icon_tooltip = nil)` [SketchUp 2017] — Creates a new {UI::Notification} object.
- `#message` [SketchUp 2017] — Gets the message as string.
- `#message=(message)` [SketchUp 2017] — Sets a new message
- `#on_accept(title, block)` [SketchUp 2017] — Shows a button in the notification with the given title and callback block, both arguments are required.
- `#on_accept_title` [SketchUp 2017] — Returns the accept's button title.
- `#on_dismiss(title, block)` [SketchUp 2017] — Shows a button in the notification with the given title and callback block
- `#on_dismiss_title` [SketchUp 2017] — Returns the dismiss's button title.
- `#show` [SketchUp 2017] — Shows the notification

## UI::Toolbar
_UI/Toolbar.rb_ [SketchUp 6.0]

The Toolbar class contains methods to create and manipulate SketchUp

- `.new(toolbarname)` [SketchUp 6.0] — The new method creates a new Toolbar object.
- `#add_item(command)` [SketchUp 6.0] — The add_item method is used to add an item to the toolbar.
- `#add_separator(arg)` [SketchUp 6.0] — The add_separator method is used to add a line separator to the toolbar.
- `#count` [SketchUp 2014] — The {#count} method is inherited from the +Enumerable+ mix-in module.
- `#each` [SketchUp 8.0 M1] — The {#each} method is used to iterate through all of the commands attached to a toolbar.
- `#get_last_state` [SketchUp 6.0] — The get_last_state method is used to determine if the toolbar was hidden or visible in the previous session of SketchUp
- `#hide` [SketchUp 6.0] — The hide method is used to hide the toolbar on the user interface.
- `#length` [SketchUp 2014] — The {#length} method returns the number of items in the toolbar.
- `#name` [SketchUp 8.0 M1] — The name method returns the name of the toolbar.
- `#restore` [SketchUp 6.0] — The restore method is used to reposition the toolbar to its previous location and show if not hidden.
- `#show` [SketchUp 6.0] — The show method is used to display the toolbar in the user interface.
- `#size` [SketchUp 2014] — The {#size} method is an alias of {#length}.
- `#visible?` [SketchUp 6.0] — The visible? method is used to find out if a toolbar is currently visible.

## UI::WebDialog
_UI/WebDialog.rb_ [SketchUp 6.0]

The Ruby WebDialog class allows you to create and interact with DHTML dialog

- `#add_action_callback(callback_name)` [SketchUp 6.0] — The add_action_callback method establishes a Ruby callback method that your web dialog can call to perform some function
- `#allow_actions_from_host(hostname)` [SketchUp 6.0] — By default, actions are only allowed on the host where the webdialog is displayed
- `#bring_to_front` [SketchUp 6.0] — The bring_to_front method is used to bring the webdialog to the front of all the windows on the desktop
- `#close` [SketchUp 6.0] — The close method is used to close the webdialog.
- `#execute_script(script)` [SketchUp 6.0] — The execute_script method is used to execute a JavaScript string on the web dialog.
- `#get_default_dialog_color` [SketchUp 6.0] — The get_default_dialog_color method is used to get the default dialog color for the web dialog.
- `#get_element_value(element_id)` [SketchUp 6.0] — The get_element_value method is used to get a value, with a given element_id, from the web dialog's DOM.
- `#initialize(dialog_title = "", scrollable = true, pref_key = nil, width = 250, height = 250, left = 0, top = 0, resizable = true)` [SketchUp 7.0] — The +new+ method is used to create a new webdialog.
- `#max_height` [SketchUp 7.0] — The max_height method is used to get the maximum height that the user is allowed to resize the dialog to.
- `#max_height=(height)` [SketchUp 7.0] — The max_height= method is used to set the maximum height that the user is allowed to resize the dialog to.
- `#max_width` [SketchUp 7.0] — The max_width method is used to get the maximum width that the user is allowed to resize the dialog to.
- `#max_width=(width)` [SketchUp 7.0] — The max_width= method is used to set the maximum width that the user is allowed to resize the dialog to.
- `#min_height` [SketchUp 7.0] — The min_width method is used to get the minimum height that the user is allowed to resize the dialog to.
- `#min_height=(height)` [SketchUp 7.0] — The min_height= method is used to set the minimum height that the user is allowed to resize the dialog to.
- `#min_width` [SketchUp 7.0] — The min_width method is used to get the minimum width that the user is allowed to resize the dialog to.
- `#min_width=(width)` [SketchUp 7.0] — The min_width= method is used to set the minimum width that the user is allowed to resize the dialog to.
- `#navigation_buttons_enabled=(nav_buttons)` [SketchUp 7.0] — The navigation_buttons_enabled= method is used to set whether the home, next, and back buttons are visible at the top of the WebDialog on the mac
- `#navigation_buttons_enabled?` [SketchUp 7.0] — The navigation_buttons_enabled? method is used to get whether the home, next, and back buttons are visible at the top of the WebDialog on the mac
- `#post_url(url, data)` [SketchUp 6.0] — The post_url method is used to send the data to a url using the HTTP POST method.
- `#screen_scale_factor` [SketchUp 2014] — The screen_scale_factor method returns the ratio of screen pixels to logical window units (called 'points' on Mac) for the screen this WebDialog is cu
- `#set_background_color(color)` [SketchUp 6.0] — The set_background_color method is used to set the background color for the webdialog.
- `#set_file(filename, path = nil)` [SketchUp 6.0] — The {#set_file} method is used to identify a local HTML file to display in the webdialog.
- `#set_full_security` [SketchUp 7.0] — The set_full_security method is used to place the WebDialog into a higher security mode where remote URLs and plugins (such as Flash) are not allowed 
- `#set_html(html_string)` [SketchUp 6.0] — The set_html method is used to load a webdialog with a string of provided HTML.
- `#set_on_close` [SketchUp 6.0] — The set_on_close method is used to establish one or more activities to perform when the dialog closes (such as saving values stored in the dialog).
- `#set_position(left, top)` [SketchUp 6.0] — The set_position method is used to set the position of the webdialog relative to the screen, in pixels.
- `#set_size(w, h)` [SketchUp 6.0] — The set_size method is used to set the size of the webdialog, in pixels.
- `#set_url(url)` [SketchUp 6.0] — The set_url method is used to load a webdialog with the content at a specific URL
- `#show` [SketchUp 6.0] — The show method is used to display a non-modal dialog box.
- `#show_modal` [SketchUp 6.0] — The show_modal method is used to display a modal dialog box
- `#visible?` [SketchUp 6.0] — The visible? method is used to tell if the webdialog is currently shown.
- `#write_image(image_path, option, top_left_x, top_left_y, bottom_right_x, bottom_right_y)` [SketchUp 7.1] — The write_image method is used to grab a portion of the web dialog screen and save the image to the given file path.

## _top_level.rb
__top_level.rb_ 



Constants: ALT_MODIFIER_KEY, ALT_MODIFIER_MASK, COPY_MODIFIER_KEY, COPY_MODIFIER_MASK, CONSTRAIN_MODIFIER_KEY, CONSTRAIN_MODIFIER_MASK, CMD_ARC, CMD_CAMERA_UNDO, CMD_CIRCLE, CMD_COPY, CMD_CUT, CMD_DELETE, CMD_DIMENSION, CMD_DISPLAY_FOV, CMD_DOLLY, CMD_DRAWCUTS, CMD_DRAWOUTLINES, CMD_ERASE, CMD_EXTRUDE, CMD_FREEHAND, CMD_HIDDENLINE, CMD_LINE, CMD_MAKE_COMPONENT, CMD_MEASURE, CMD_MOVE, CMD_NEW, CMD_OFFSET, CMD_OPEN, CMD_ORBIT, CMD_PAGE_DELETE, CMD_PAGE_NEW, CMD_PAGE_NEXT, CMD_PAGE_PREVIOUS, CMD_PAGE_UPDATE, CMD_PAINT, CMD_PAN, CMD_PASTE, CMD_POLYGON, CMD_POSITION_CAMERA, CMD_PRINT, CMD_PROTRACTOR, CMD_PUSHPULL, CMD_RECTANGLE, CMD_REDO, CMD_ROTATE, CMD_RUBY_CONSOLE, CMD_SAVE, CMD_SCALE, CMD_SECTION, CMD_SELECT, CMD_SELECTION_ZOOM_EXT, CMD_SHADED, CMD_SHOWGUIDES, CMD_SHOWHIDDEN, CMD_SHOWHIDDENGEOMETRY, CMD_SHOWHIDDENOBJECTS, CMD_SKETCHAXES, CMD_SKETCHCS, CMD_TEXT, CMD_TEXTURED, CMD_TRANSPARENT, CMD_UNDO, CMD_VIEW_BACK, CMD_VIEW_BOTTOM, CMD_VIEW_FRONT, CMD_VIEW_ISO, CMD_VIEW_LEFT, CMD_VIEW_PERSPECTIVE, CMD_VIEW_RIGHT, CMD_VIEW_TOP, CMD_WALK, CMD_WIREFRAME, CMD_ZOOM, CMD_ZOOM_EXTENTS, CMD_ZOOM_WINDOW, FILE_WRITE_FAILED_INVALID_TYPE, FILE_WRITE_FAILED_UNKNOWN, FILE_WRITE_OK, GL_LINES, GL_LINE_LOOP, GL_LINE_STRIP, GL_POINTS, GL_POLYGON, GL_QUADS, GL_QUAD_STRIP, GL_TRIANGLES, GL_TRIANGLE_FAN, GL_TRIANGLE_STRIP, IDENTITY, IDENTITY_2D, IDABORT, IDCANCEL, IDIGNORE, IDNO, IDOK, IDRETRY, IDYES, LAYER_HIDDEN_BY_DEFAULT, LAYER_IS_HIDDEN_ON_NEW_PAGES, LAYER_IS_VISIBLE_ON_NEW_PAGES, LAYER_USES_DEFAULT_VISIBILITY_ON_NEW_PAGES, LAYER_VISIBLE_BY_DEFAULT, MB_ABORTRETRYIGNORE, MB_MULTILINE, MB_OK, MB_OKCANCEL, MB_RETRYCANCEL, MB_YESNO, MB_YESNOCANCEL, MF_CHECKED, MF_DISABLED, MF_ENABLED, MF_GRAYED, MF_UNCHECKED, ORIGIN, ORIGIN_2D, PAGE_NO_CAMERA, PAGE_USE_ALL, PAGE_USE_CAMERA, PAGE_USE_ENVIRONMENT, PAGE_USE_HIDDEN, PAGE_USE_HIDDEN_GEOMETRY, PAGE_USE_HIDDEN_OBJECTS, PAGE_USE_LAYER_VISIBILITY, PAGE_USE_RENDERING_OPTIONS, PAGE_USE_SECTION_PLANES, PAGE_USE_SHADOWINFO, PAGE_USE_SKETCHCS, SB_PROMPT, SB_VCB_LABEL, SB_VCB_VALUE, SKETCHUP_CONSOLE, TB_HIDDEN, TB_NEVER_SHOWN, TB_VISIBLE, VK_ALT, VK_COMMAND, VK_CONTROL, VK_DELETE, VK_DOWN, VK_END, VK_HOME, VK_INSERT, VK_LEFT, VK_MENU, VK_NEXT, VK_PRIOR, VK_RIGHT, VK_SHIFT, VK_SPACE, VK_UP, X_AXIS_2D, Y_AXIS_2D, X_AXIS, Y_AXIS, Z_AXIS

- `#add_separator_to_menu(menu_name)` [SketchUp 6.0] — Instance Methods
- `#file_loaded(filename)` [SketchUp 6.0] — Call this function at the end of a file that you are loading to let the system know that you have loaded it.
- `#file_loaded?(filename)` [SketchUp 6.0] — Use in combination with {#file_loaded} to create load guards for code you don't want to reload
- `#inputbox(*args)` [SketchUp 6.0] — This is a wrapper for {UI.inputbox}
- `#require_all(dirname)` [SketchUp 6.0] **DEPRECATED** — By default, SketchUp automatically loads (using require) all files with the .rb extension in the plugins directory
- `#show_ruby_panel` [SketchUp 6.0] **DEPRECATED** — This global method is called by the Ruby Console menu item
