extends VBoxContainer

# =============================
# backing fields and properties
# =============================
var _multiMesh: MultiMesh = null setget setMultiMesh, getMultiMesh

func setMultiMesh(value: MultiMesh) -> void:
    _multiMesh = value
    if _multiMesh == null:
        _newMultiMeshButton.pressed = false
        _newMultiMeshButton.text = "New"
        _gridContainer2.visible = false
    else:
        _newMultiMeshButton.pressed = true
        _newMultiMeshButton.text = "MultiMesh"
        _gridContainer2.visible = true

func getMultiMesh() -> MultiMesh:
    return _multiMesh

# ==============
# private fields
# ==============
onready var _gridContainer2 := $"Margin 2/GridContainer"
onready var _newMultiMeshButton := $"Margin 1/GridContainer/NewMultiMeshButton"

# ========================
# overwritten base methods
# ========================
func _ready() -> void:
    setMultiMesh(_multiMesh)

    _newMultiMeshButton.connect("toggled", self, "OnNewMultiMeshButtonToggle")

# ==============
# signal handler
# ==============
func OnNewMultiMeshButtonToggle(pressed: bool) -> void:
    if pressed:
        var mm := MultiMesh.new()
        mm.transform_format = MultiMesh.TRANSFORM_3D
        setMultiMesh(mm)
    else:
        setMultiMesh(null)
