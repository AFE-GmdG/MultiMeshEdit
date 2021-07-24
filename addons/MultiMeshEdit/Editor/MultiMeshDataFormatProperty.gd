extends EditorProperty
class_name MultiMeshDataFormatProperty

var _inspectorPlugin: MultiMeshInspectorPlugin
var _dataFormatDropdown: OptionButton

func _init(inspectorPlugin: MultiMeshInspectorPlugin) -> void:
    _inspectorPlugin = inspectorPlugin

func _enter_tree() -> void:
    _dataFormatDropdown = OptionButton.new()
    _dataFormatDropdown.clip_text = true
    _dataFormatDropdown.expand_icon = true
    _dataFormatDropdown.flat = true
    _dataFormatDropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL

    _dataFormatDropdown.add_item("None", MultiMesh.CUSTOM_DATA_NONE)
    _dataFormatDropdown.add_item("Byte", MultiMesh.CUSTOM_DATA_8BIT)
    _dataFormatDropdown.add_item("Float", MultiMesh.CUSTOM_DATA_FLOAT)
    _dataFormatDropdown.select(_dataFormatDropdown.get_item_index(_inspectorPlugin._multiMesh.custom_data_format))

    add_child(_dataFormatDropdown)
    _dataFormatDropdown.connect("item_selected", self, "OnChanged")

func _exit_tree() -> void:
    _dataFormatDropdown.disconnect("item_selected", self, "OnChanged")

func OnChanged(index: int) -> void:
    _inspectorPlugin.update_data_format(_dataFormatDropdown.get_item_id(index))
