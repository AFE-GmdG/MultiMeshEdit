extends EditorInspectorPlugin
class_name MultiMeshInspectorPlugin

var _multiMesh: MultiMesh
var _colorData: PoolColorArray = []
var _customData: PoolColorArray = []
var _transform2DData: PoolVector2Array = []
var _transform3DData: PoolVector3Array = []
var _selectedInstance: int = 0 setget setSelectedInstance, getSelectedInstance

func setSelectedInstance(value: int) -> void:
    if _multiMesh == null:
        return
    _selectedInstance = max(0, min(_multiMesh.instance_count - 1, value))

func getSelectedInstance() -> int:
    if _multiMesh == null:
        return 0
    return _selectedInstance

func can_handle(object: Object) -> bool:
    _multiMesh = object as MultiMesh
    return _multiMesh != null

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
    # print("parseProperty: %s, %d, %s, %d, %s, %d" % [object, type, path, hint, hint_text, usage])
    if path == "color_format":
        add_property_editor(path, load("res://addons/MultiMeshEdit/Editor/MultiMeshColorFormatProperty.gd").new(self))
        return true
    if path == "custom_data_format":
        add_property_editor(path, load("res://addons/MultiMeshEdit/Editor/MultiMeshDataFormatProperty.gd").new(self))
        return true
    if path == "mesh":
        add_custom_control(load("res://addons/MultiMeshEdit/Editor/MultiMeshInstanceTransformProperty.gd").new(self))
    return false

func _create_or_update_backup() -> void:
    if _multiMesh.instance_count == 0:
        return
    if _multiMesh.instance_count > _colorData.size():
        _colorData.resize(_multiMesh.instance_count)

    if _multiMesh.instance_count > _customData.size():
        _customData.resize(_multiMesh.instance_count)

    if _multiMesh.transform_format == MultiMesh.TRANSFORM_2D and _multiMesh.instance_count * 3 > _transform2DData.size():
        _transform2DData.resize(_multiMesh.instance_count * 3)
    if _multiMesh.transform_format == MultiMesh.TRANSFORM_3D and _multiMesh.instance_count * 4 > _transform3DData.size():
        _transform3DData.resize(_multiMesh.instance_count * 4)

    if _multiMesh.color_format != MultiMesh.COLOR_NONE:
        for index in _multiMesh.instance_count:
            _colorData[index] = _multiMesh.get_instance_color(index)
    if _multiMesh.custom_data_format != MultiMesh.CUSTOM_DATA_NONE:
        for index in _multiMesh.instance_count:
            _customData[index] = _multiMesh.get_instance_custom_data(index)

    if _multiMesh.transform_format == MultiMesh.TRANSFORM_2D:
        for index in _multiMesh.instance_count:
            var t := _multiMesh.get_instance_transform_2d(index)
            _transform2DData[index * 3 + 0] = t.x
            _transform2DData[index * 3 + 1] = t.y
            _transform2DData[index * 3 + 2] = t.origin

    if _multiMesh.transform_format == MultiMesh.TRANSFORM_3D:
        for index in _multiMesh.instance_count:
            var t := _multiMesh.get_instance_transform(index)
            _transform3DData[index * 4 + 0] = t.basis.x
            _transform3DData[index * 4 + 1] = t.basis.y
            _transform3DData[index * 4 + 2] = t.basis.z
            _transform3DData[index * 4 + 3] = t.origin

func _restore_backup() -> void:
    if _multiMesh.instance_count == 0:
        return
    if _multiMesh.color_format != MultiMesh.COLOR_NONE:
        for index in _multiMesh.instance_count:
            _multiMesh.set_instance_color(index, _colorData[index])
    if _multiMesh.custom_data_format != MultiMesh.CUSTOM_DATA_NONE:
        for index in _multiMesh.instance_count:
            _multiMesh.set_instance_custom_data(index, _customData[index])

    if _multiMesh.transform_format == MultiMesh.TRANSFORM_2D:
        for index in _multiMesh.instance_count:
            var t := Transform2D(
                _transform2DData[index * 3 + 0],
                _transform2DData[index * 3 + 1],
                _transform2DData[index * 3 + 2]
            )
            _multiMesh.set_instance_transform_2d(index, t)
    if _multiMesh.transform_format == MultiMesh.TRANSFORM_3D:
        for index in _multiMesh.instance_count:
            var t := Transform(
                Basis(
                    _transform3DData[index * 4 + 0],
                    _transform3DData[index * 4 + 1],
                    _transform3DData[index * 4 + 2]
                ),
                _transform3DData[index * 4 + 3]
            )
            _multiMesh.set_instance_transform(index, t)

func update_color_format(newColorFormat: int) -> void:
    _create_or_update_backup()
    var instanceCount := _multiMesh.instance_count
    var visibleInstanceCount := _multiMesh.visible_instance_count
    _multiMesh.visible_instance_count = 0
    _multiMesh.instance_count = 0
    _multiMesh.color_format = newColorFormat
    _multiMesh.instance_count = instanceCount
    _restore_backup()
    _multiMesh.visible_instance_count = visibleInstanceCount

func update_data_format(newDataFormat: int) -> void:
    _create_or_update_backup()
    var instanceCount := _multiMesh.instance_count
    var visibleInstanceCount := _multiMesh.visible_instance_count
    _multiMesh.visible_instance_count = 0
    _multiMesh.instance_count = 0
    _multiMesh.custom_data_format = newDataFormat
    _multiMesh.instance_count = instanceCount
    _restore_backup()
    _multiMesh.visible_instance_count = visibleInstanceCount
