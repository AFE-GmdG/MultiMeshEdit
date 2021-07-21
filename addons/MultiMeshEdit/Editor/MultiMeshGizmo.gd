extends EditorSpatialGizmo
class_name MultiMeshGizmo

# Example for working with handles:
# https://gist.github.com/HungryProton/b67fefe76082cb04cfc48842fb1aa270

var _pressed: bool = false
var _p0: Vector3
var _p1: Vector3
var _transform: Transform
var _movedDistance: float

# Wird aufgerufen, sobald man auf einen Handle klickt - sowie in jedem MouseMove
# Sollte einen Wert zurückgeben.
func get_handle_value(index: int):
    var instanceIndex: int = index / 4
    var handleId: int = index % 4
    var mmi := get_spatial_node() as MultiMeshInstance
    var transform := mmi.multimesh.get_instance_transform(instanceIndex)

    if not _pressed:
        _p0 = transform.origin
        _p1 = transform.origin
        match handleId:
            1: _p1 += Vector3(0.25, 0, 0)
            2: _p1 += Vector3(0, 0.25, 0)
            3: _p1 += Vector3(0, 0, 0.25)
        _pressed = true
        _transform = transform
        _movedDistance = 0

    print("GetHandleValue: %s" % transform.origin)
    return transform

# Wird aufgerufen, wenn man am Handle zieht.
func set_handle(index: int, camera: Camera, point: Vector2) -> void:
    var instanceIndex: int = index / 4
    var handleId: int = index % 4
    if handleId == 0:
        print ("Not implemented yet")
        return
    var mmi := get_spatial_node() as MultiMeshInstance
    var globalTransform := _transform * mmi.global_transform
    var globalInverse := globalTransform.affine_inverse()
    var rayFrom := camera.project_ray_origin(point)
    var rayDir := camera.project_ray_normal(point)
    var d := _p1 - _p0
    var p1 = _p0 - (10 * d)
    var p2 = _p0 + (10 * d)
    var g1 = globalInverse.xform(rayFrom)
    var g2 = globalInverse.xform(rayFrom + rayDir * 1000)
    var points := Geometry.get_closest_points_between_segments(p1, p2, g1, g2)
    _movedDistance = points[0][handleId - 1] - _p1[handleId - 1]
    var translated := Vector3(0, 0, 0)
    translated[handleId - 1] = _movedDistance
    mmi.multimesh.set_instance_transform(instanceIndex, _transform.translated(translated))
    print("%s - %s - %f" % [points[0], points[1], _movedDistance])

func commit_handle(index: int, restore, cancel: bool = false) -> void:
    _pressed = false
    print("CommitHandle: %d, %s, %s" % [index, restore, cancel])
    var instanceIndex: int = index / 4
    var handleId: int = index % 4
    var mmi := get_spatial_node() as MultiMeshInstance
    if cancel or handleId == 0:
        mmi.multimesh.set_instance_transform(instanceIndex, _transform)
        return
    var translated := Vector3(0, 0, 0)
    translated[handleId - 1] = _movedDistance
    mmi.multimesh.set_instance_transform(instanceIndex, _transform.translated(translated))


# Wird aufgerufen, wenn man am Handle zieht.
# Habe noch nicht herausgefunden, wo der Name angezeigt wird - wenn überhaupt.
#func get_handle_name(index: int) -> String:
#    print("Instance %d" % index)
#    return "Instance %d" % index

# Wird oft durch den Editor aufgerufen; gibst du false zurück, wird der Handle rot angezeigt, bei true blau
#func is_handle_highlighted(index: int) -> bool:
#    print("IsHandleHighlighted: %d" % index)
#    return false

# Wird oft durch den Editor aufgerufen; alle add_* Funktionen müssen hier aufgerufen werden.
func redraw() -> void:
    clear()
    var mmi := get_spatial_node() as MultiMeshInstance
    # print("Redraw: %s" % mmi.name)

    if mmi.multimesh == null || mmi.multimesh.mesh == null:
        return

    var gizmo := get_plugin()
    var handleMaterial = gizmo.get_material("handles", self)
    # print(handleMaterial)

    var aabb := mmi.multimesh.mesh.get_aabb()
    var points := PoolVector3Array()
    var indices := PoolIntArray()
    var lines := PoolVector3Array()
    var points2 := PoolVector3Array()
    var colors2 := PoolColorArray()
    var handles := PoolVector3Array()
    var p0 := Vector3(0, 0, 0)
    var px := Vector3(0.25, 0, 0)
    var py := Vector3(0, 0.25, 0)
    var pz := Vector3(0, 0, 0.25)
    for i in mmi.multimesh.instance_count:
        var transform := mmi.multimesh.get_instance_transform(i)
        for j in 8:
            points.push_back(transform.xform(aabb.get_endpoint(j)))

        var baseIndex: int = i * 8
        indices.push_back(baseIndex + 3)
        indices.push_back(baseIndex + 5)
        indices.push_back(baseIndex + 1)
        indices.push_back(baseIndex + 3)
        indices.push_back(baseIndex + 7)
        indices.push_back(baseIndex + 5)
        indices.push_back(baseIndex + 7)
        indices.push_back(baseIndex + 4)
        indices.push_back(baseIndex + 5)
        indices.push_back(baseIndex + 7)
        indices.push_back(baseIndex + 6)
        indices.push_back(baseIndex + 4)
        indices.push_back(baseIndex + 6)
        indices.push_back(baseIndex + 0)
        indices.push_back(baseIndex + 4)
        indices.push_back(baseIndex + 6)
        indices.push_back(baseIndex + 2)
        indices.push_back(baseIndex + 0)
        indices.push_back(baseIndex + 2)
        indices.push_back(baseIndex + 1)
        indices.push_back(baseIndex + 0)
        indices.push_back(baseIndex + 2)
        indices.push_back(baseIndex + 3)
        indices.push_back(baseIndex + 1)
        indices.push_back(baseIndex + 2)
        indices.push_back(baseIndex + 7)
        indices.push_back(baseIndex + 3)
        indices.push_back(baseIndex + 2)
        indices.push_back(baseIndex + 6)
        indices.push_back(baseIndex + 7)
        indices.push_back(baseIndex + 1)
        indices.push_back(baseIndex + 4)
        indices.push_back(baseIndex + 0)
        indices.push_back(baseIndex + 1)
        indices.push_back(baseIndex + 5)
        indices.push_back(baseIndex + 4)

        lines.push_back(points[baseIndex + 0])
        lines.push_back(points[baseIndex + 1])
        lines.push_back(points[baseIndex + 1])
        lines.push_back(points[baseIndex + 5])
        lines.push_back(points[baseIndex + 5])
        lines.push_back(points[baseIndex + 4])
        lines.push_back(points[baseIndex + 4])
        lines.push_back(points[baseIndex + 0])
        lines.push_back(points[baseIndex + 2])
        lines.push_back(points[baseIndex + 3])
        lines.push_back(points[baseIndex + 3])
        lines.push_back(points[baseIndex + 7])
        lines.push_back(points[baseIndex + 7])
        lines.push_back(points[baseIndex + 6])
        lines.push_back(points[baseIndex + 6])
        lines.push_back(points[baseIndex + 2])
        lines.push_back(points[baseIndex + 0])
        lines.push_back(points[baseIndex + 2])
        lines.push_back(points[baseIndex + 1])
        lines.push_back(points[baseIndex + 3])
        lines.push_back(points[baseIndex + 5])
        lines.push_back(points[baseIndex + 7])
        lines.push_back(points[baseIndex + 4])
        lines.push_back(points[baseIndex + 6])

        var lp0 = transform.xform(p0)
        var lpx = transform.xform(px)
        var lpy = transform.xform(py)
        var lpz = transform.xform(pz)
        points2.push_back(lp0)
        points2.push_back(lpx)
        colors2.push_back(Color(1, 0, 0))
        colors2.push_back(Color(1, 0, 0))
        points2.push_back(lp0)
        points2.push_back(lpy)
        colors2.push_back(Color(0, 1, 0))
        colors2.push_back(Color(0, 1, 0))
        points2.push_back(lp0)
        points2.push_back(lpz)
        colors2.push_back(Color(0, 0, 1))
        colors2.push_back(Color(0, 0, 1))

        handles.push_back(lp0)
        handles.push_back(lpx)
        handles.push_back(lpy)
        handles.push_back(lpz)

    var a := Array()
    a.resize(ArrayMesh.ARRAY_MAX)
    a[ArrayMesh.ARRAY_VERTEX] = points
    a[ArrayMesh.ARRAY_INDEX] = indices
    var am := ArrayMesh.new()
    am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, a, [], 0)
    var tm := am.generate_triangle_mesh()

    a.clear()
    a.resize(ArrayMesh.ARRAY_MAX)
    a[ArrayMesh.ARRAY_VERTEX] = points2
    a[ArrayMesh.ARRAY_COLOR] = colors2
    am = ArrayMesh.new()
    am.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, a, [], 0)

    add_handles(handles, handleMaterial)
    add_lines(lines, gizmo.get_material("lines", self))
    add_mesh(am, false, null, gizmo.get_material("gizmoLines", self))

    add_collision_triangles(tm)

    lines.resize(0)
    if _pressed:
        var d := _p1 - _p0
        lines.push_back(_p0 - (10 * d))
        lines.push_back(_p0 + (10 * d))
        add_lines(lines, gizmo.get_material("lines", self))
