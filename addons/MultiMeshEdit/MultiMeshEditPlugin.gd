tool
extends EditorPlugin
class_name MultiMeshEditPlugin

# https://github.com/Zylann/godot_heightmap_plugin/blob/master/addons/zylann.hterrain/tools/plugin.gd

const MENU_INFO = 0

var _gizmoPlugin: MultiMeshGizmoPlugin = null
var _inspectorPlugin: MultiMeshInspectorPlugin = null
var _toolbar: HBoxContainer = null
var _menu_button: Button = null
var _multiMeshInstanceIcon: Texture = preload("res://addons/MultiMeshEdit/Editor/MultiMeshInstance.svg")

# var _transformArray: Array = []
# var _currentMultiMeshInstance: MultiMeshInstance = null

func _enter_tree() -> void:
    print("===================")
    print("MultiMeshEditPlugin")
    print("===================")

    _toolbar = HBoxContainer.new()
    add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _toolbar)
    _toolbar.hide()

    _gizmoPlugin = MultiMeshGizmoPlugin.new()
    add_spatial_gizmo_plugin(_gizmoPlugin)

    _inspectorPlugin = MultiMeshInspectorPlugin.new()
    add_inspector_plugin(_inspectorPlugin)

    _menu_button = Button.new()
    _menu_button.text = "MultiMeshEditor"
    _menu_button.icon = _multiMeshInstanceIcon
    _menu_button.toggle_mode = true
    _menu_button.connect("toggled", self, "onMultiMeshEditorToggled")
    _toolbar.add_child(_menu_button)

func _exit_tree() -> void:
    edit(null)
    _toolbar.queue_free()
    _toolbar = null

    remove_inspector_plugin(_inspectorPlugin)
    remove_spatial_gizmo_plugin(_gizmoPlugin)

    print("========================")
    print("End: MultiMeshEditPlugin")
    print("========================")

func handles(object: Object) -> bool:
    return object is MultiMeshInstance

func edit(object: Object) -> void:
    if object == null:
        _menu_button.pressed = false
#        _cleanCurrentTransformArray()
        return
    var multiMeshInstance: MultiMeshInstance = object
#    if multiMeshInstance != _currentMultiMeshInstance:
#        _cleanCurrentTransformArray()
#    var multiMesh: MultiMesh = multiMeshInstance.multimesh
#    if multiMesh == null:
#        return
#    if _currentMultiMeshInstance == null:
#        _currentMultiMeshInstance = multiMeshInstance
#        _transformArray.resize(multiMesh.instance_count)
#        for i in multiMesh.instance_count:
#            var transform := multiMesh.get_instance_transform(i)
#            var spatial := MeshInstance.new()
#            var cubeMesh := CubeMesh.new()
#            cubeMesh.size = Vector3(0.4, 0.4, 0.4)
#            spatial.mesh = cubeMesh
#            spatial.transform = transform
#            multiMeshInstance.add_child(spatial)
#            _transformArray[i] = spatial

func make_visible(visible: bool) -> void:
    _toolbar.visible = visible
    if not visible:
        edit(null)

func onMultiMeshEditorToggled(pressed: bool) -> void:
    # print(pressed)
    if pressed:
        pass

#func _cleanCurrentTransformArray() -> void:
#    if _currentMultiMeshInstance != null:
#        for transformObject in _transformArray:
#            var transformSpatial := transformObject as Spatial
#            if transformSpatial != null:
#                _currentMultiMeshInstance.remove_child(transformSpatial)
#                transformSpatial.queue_free()
#        _transformArray.clear()
#        _currentMultiMeshInstance = null
#    else:
#        for transformObject in _transformArray:
#            var transformSpatial := transformObject as Spatial
#            if transformSpatial != null and transformSpatial.get_parent() != null:
#                transformSpatial.get_parent().remove_child(transformSpatial)
#                transformSpatial.queue_free()
#        _transformArray.clear()
