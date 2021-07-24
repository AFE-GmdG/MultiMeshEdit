extends EditorProperty
class_name MultiMeshEditorProperty

var MMEditor := preload("res://addons/MultiMeshEdit/Editor/MultiMeshEditor.tscn")
var _mmEditor: GridContainer
var _button: Button

func _init() -> void:
    print("MultiMeshEditorProperty -> Init")
    _mmEditor = MMEditor.instance()
    add_child(_mmEditor)
    set_bottom_editor(_mmEditor)

func _enter_tree() -> void:
    print("MultiMeshEditorProperty -> Enter Tree")

func _ready() -> void:
    print("MultiMeshEditorProperty -> Ready")
    _button = _mmEditor.get_node("Button")
    _button.connect("pressed", self, "OnButtonClick")

func _exit_tree() -> void:
    print("MultiMeshEditorProperty -> Exit Tree")
    _button.disconnect("pressed", self, "OnButtonClick")

func OnButtonClick() -> void:
    var parent: Node = get_parent().get_parent().get_parent()
    # while parent != null:
    #     print("OnButtonClick: %s - %s" % [parent, parent.get_class()])
    #     parent = parent.get_parent()
    printNodes(parent, 1)

func printNodes(node: Node, indent: int) -> void:
    print("%4d:%s%-30s%s(%s)" % [
        indent,
        " ".repeat(indent * 2),
        node.get_class(),
        " ".repeat(20 - indent * 2),
        node.get_text() if node.has_method("get_text") else ""
    ])
    for subNode in node.get_children():
        printNodes(subNode, indent + 1)
