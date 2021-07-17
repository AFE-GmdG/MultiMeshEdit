# MultiMeshEdit
Godot addon to edit MultiMeshInstances

## Hint:
Currently under development, will be added to AssetStore as soon as it is usable

I only add nodes that are of excellent code quality, that are tested well. But I'm only a human; even I could do errors. If you find one, please add an issue to the
[Github Issue Page](https://github.com/AFE-GmdG/MultiMeshEdit/issues).

Greetings, Andreas

## Usage:
MultiMeshEdit is an editor plugin. You can move, rotate and scale individual mesh instances of a MultiMeshInstance.

Since I'm currently not able to add the "standard" Translate/Rotate/Scale gizmo, I used a bunch of handles (the red dots). \
There are 7 dots per mesh. The 3 dots on the X/Y/Z axis are to translate the mesh, the 3 Dots on the arcs are to rotate the mesh
and the dot in the center is to scale the mesh.

Additionally in the top of the EditorWindow is the MultiMesh Menu for
- Adding another instance
- A dialog with settings of the MultiMeshInstance
- A dialog with the numeric translate / rotate / scale values for each instance

## Version
### 0.0.1
- First iteration
- Adding AABB around each instance with the ability to click on it.
  - Sadly there is no way to only activate a single instance. Help is appreciated.
- Adding Translate/Rotate/Scale GizmoMesh with handles for translation and scale
  - Rotation will follow
- Adding DemoScene

## Next steps:
- Add instance menu entry
- Settings dialog
- Numeric value dialog
