extends EditorProperty
class_name MultiMeshInstanceTransformProperty

var _inspectorPlugin: MultiMeshInspectorPlugin
var MMITEditor := preload("res://addons/MultiMeshEdit/Editor/MultiMeshInstanceTransformEditor.tscn")

var _prevButton: Button;
var _instanceSlider: Slider;
var _instanceLabel: Label;
var _nextButton: Button;

func _init(inspectorPlugin: MultiMeshInspectorPlugin) -> void:
    _inspectorPlugin = inspectorPlugin
    label = "Instance Transform"

func _enter_tree() -> void:
    var editor = MMITEditor.instance()
    _prevButton = editor.get_node("InstanceSelector/PrevButton")
    _prevButton.connect("pressed", self, "OnPrevButtonClick")
    _instanceSlider = editor.get_node("InstanceSelector/InstanceSlider")
    _instanceLabel = editor.get_node("InstanceSelector/InstanceLabel")
    _nextButton = editor.get_node("InstanceSelector/NextButton")
    _nextButton.connect("pressed", self, "OnNextButtonClick")

    _inspectorPlugin.setSelectedInstance(0)
    _prevButton.disabled = true
    _nextButton.disabled = _inspectorPlugin.getSelectedInstance() + 1 == _inspectorPlugin._multiMesh.instance_count

    add_child(editor)
    set_bottom_editor(editor)

func _exit_tree() -> void:
    _prevButton.disconnect("pressed", self, "OnPrevButtonClick")
    _nextButton.disconnect("pressed", self, "OnNextButtonClick")

func get_tooltip_text() -> String:
    return "Set instance specific transform, color and custom data."

func OnPrevButtonClick() -> void:
    print("prev")
    _inspectorPlugin.setSelectedInstance(_inspectorPlugin.getSelectedInstance() - 1)
    emit_changed("multimesh", _inspectorPlugin._multiMesh)
    update_property()

func OnNextButtonClick() -> void:
    print("next")
    _inspectorPlugin.setSelectedInstance(_inspectorPlugin.getSelectedInstance() + 1)
    emit_changed("multimesh", _inspectorPlugin._multiMesh)
    update_property()

func update_property() -> void:
    print("UpdateProperty")
    if _prevButton == null:
        return;
    if _inspectorPlugin._multiMesh.instance_count == 0:
        _prevButton.disabled = true
        _instanceSlider.min_value = 0
        _instanceSlider.max_value = 1
        _instanceSlider.value = 0
        _instanceSlider.editable = false
        _instanceLabel.text = "%4d" % 0
        _nextButton.disabled = true
    else:
        _prevButton.disabled = _inspectorPlugin.getSelectedInstance() == 0
        _instanceSlider.min_value = 0
        _instanceSlider.max_value = _inspectorPlugin._multiMesh.instance_count - 1
        _instanceSlider.value = _inspectorPlugin.getSelectedInstance()
        _instanceSlider.editable = true
        _instanceLabel.text = "%4d" % _inspectorPlugin.getSelectedInstance()
        _nextButton.disabled = _inspectorPlugin.getSelectedInstance() + 1 == _inspectorPlugin._multiMesh.instance_count
        if _inspectorPlugin._multiMesh.instance_count == 1:
            _instanceSlider.max_value = 1
            _instanceSlider.editable = false
