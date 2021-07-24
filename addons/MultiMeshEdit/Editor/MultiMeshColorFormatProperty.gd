extends EditorProperty
class_name MultiMeshColorFormatProperty

var _inspectorPlugin: MultiMeshInspectorPlugin
var _colorFormatDropdown: OptionButton

func _init(inspectorPlugin: MultiMeshInspectorPlugin) -> void:
    _inspectorPlugin = inspectorPlugin

func _enter_tree() -> void:
    _colorFormatDropdown = OptionButton.new()
    _colorFormatDropdown.clip_text = true
    _colorFormatDropdown.expand_icon = true
    _colorFormatDropdown.flat = true
    _colorFormatDropdown.size_flags_horizontal = Control.SIZE_EXPAND_FILL

    _colorFormatDropdown.add_item("None", MultiMesh.COLOR_NONE)
    _colorFormatDropdown.add_item("Byte", MultiMesh.COLOR_8BIT)
    _colorFormatDropdown.add_item("Float", MultiMesh.COLOR_FLOAT)
    _colorFormatDropdown.select(_colorFormatDropdown.get_item_index(_inspectorPlugin._multiMesh.color_format))

    add_child(_colorFormatDropdown)
    _colorFormatDropdown.connect("item_selected", self, "OnChanged")

func _exit_tree() -> void:
    _colorFormatDropdown.disconnect("item_selected", self, "OnChanged")

func OnChanged(index: int) -> void:
    _inspectorPlugin.update_color_format(_colorFormatDropdown.get_item_id(index))
