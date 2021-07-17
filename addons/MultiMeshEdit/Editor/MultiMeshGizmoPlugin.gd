extends EditorSpatialGizmoPlugin
class_name MultiMeshGizmoPlugin

func _init() -> void:
    create_handle_material("handles")
    create_material("lines", Color(1, 1, 1, 1), false, false, false)
    create_material("gizmoLines", Color(1, 1, 1, 1), false, true, true)

# Returns the name for the gizmo visibility menu.
func get_name() -> String:
    return "MultiMeshInstance"

func create_gizmo(spatial: Spatial) -> EditorSpatialGizmo:
    if spatial is MultiMeshInstance:
        return MultiMeshGizmo.new()
    return null
