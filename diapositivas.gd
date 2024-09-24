@tool
extends CanvasItem

var diapositiva_actual: int : set = cambiar_diapositiva

func _get_property_list():
	var properties = []

	properties.append({
		"name": "diapositiva_actual",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(get_children().map(func(slide: Node): return slide.name)),
	})

	return properties

func _ready():
	cambiar_diapositiva(diapositiva_actual)

func _enter_tree():
	if(get_tree().edited_scene_root == self):
		EditorInterface.get_selection().selection_changed.connect(self.on_selection_changed)

func _exit_tree():
	if(get_tree().edited_scene_root == self):
		EditorInterface.get_selection().selection_changed.disconnect(self.on_selection_changed)

func on_selection_changed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	if(selection.size() == 1 and selection.front() in get_children()):
		cambiar_diapositiva(selection.front().get_index())

func cambiar_diapositiva(indice_nuevo):
	diapositiva_actual = clamp(indice_nuevo, 0, get_child_count() - 1)
	actualizar_diapositiva_visible()

func actualizar_diapositiva_visible():
	for diapositiva in get_children() as Array[Node2D]:
		var is_active := diapositiva.get_index() == diapositiva_actual
		diapositiva.visible = is_active
	if is_inside_tree() and get_tree().edited_scene_root == self:
		var scene_tree: Tree = get_tree().root\
			.find_children("", "SceneTreeEditor", true, false).front()\
			.find_children("", "Tree", false, false).front()
		if(not scene_tree.get_root()):
			return
		for i in range(0, get_child_count()):
			scene_tree.get_root().get_child(i).collapsed = true
		scene_tree.get_root().get_child(diapositiva_actual).collapsed = false
		var presentador = get_tree().root.find_children("ControlesDePresentador", "", true, false).front()
		presentador.diapositiva_actual = diapositiva_actual

func accion_primaria():
	intentar_en_diapositiva_activa("accion_primaria")

func accion_secundaria():
	intentar_en_diapositiva_activa("accion_secundaria")

func accion_terciaria():
	intentar_en_diapositiva_activa("accion_terciaria")


func intentar_en_diapositiva_activa(metodo):
	if(diapositiva_activa().has_method(metodo)):
		diapositiva_activa().call(metodo)


func diapositiva_activa():
	return get_child(diapositiva_actual)


func avanzar():
	cambiar_diapositiva(diapositiva_actual + 1)

func retroceder():
	cambiar_diapositiva(diapositiva_actual - 1)

func _extend_inspector_begin(inspector: ExtendableInspector):
	inspector.add_custom_control(
		CommonControls.new(inspector).method_button("avanzar")
	)
	inspector.add_custom_control(
		CommonControls.new(inspector).method_button("retroceder")
	)

func _physics_process(delta):
	if is_inside_tree() and get_tree().edited_scene_root == self:
		if is_action_pressed("avanzar"):
			avanzar()
			EditorInterface.get_selection().clear()
			EditorInterface.get_selection().add_node(diapositiva_activa())
		if is_action_pressed("retroceder"):
			retroceder()
			EditorInterface.get_selection().clear()
			EditorInterface.get_selection().add_node(diapositiva_activa())


func is_action_pressed(action):
	return InputMap.has_action(action) and Input.is_action_just_pressed(action)

func _notification(what):
	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			var presentador = get_tree().root.find_children("ControlesDePresentador", "", true, false).front()
			if(presentador._is_playing_slides()):
				presentador.cerrar()
				await get_tree().process_frame
				presentador.abrir()
