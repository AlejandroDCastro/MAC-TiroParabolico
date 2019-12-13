
rollout TiroParabolico "Tiro parabolico" width:336 height:622
(
	
	-- Primer GroupBox: Tiro Parab�lico
	GroupBox 'grouptiroPar' "Tiro Parabolico" pos:[7,8] width:321 height:170
	pickbutton 'sel' "Selecciona" pos:[21,30] width:112 height:21
	button 'reset1' "Reset" pos:[21,60] width:112 height:21
	button 'borrar' "Reinicia" pos:[21,90] width:112 height:21
	label 'aviso' "" pos:[28,125]
	button 'disparo' "Dispara" pos:[21,143] width:112 height:21
	spinner 'vel' "Velocidad:" pos:[188,29] width:100 height:16 enabled:true range:[1,1800,30]
	label 'med1' "m/s" pos:[294,29] width:30 height:20
	spinner 'ang' "Angulo:" pos:[188,52] width:100 height:16 enabled:true range:[1,89,45]
	label 'med2' "º" pos:[294,52] width:30 height:20
	spinner 'grav' "Gravedad:" pos:[188,75] width:100 height:16 enabled:true range:[1,90,9.81]
	label 'med3' "m/s2" pos:[294,75] width:30 height:20
	spinner 'cai' "Caida:" pos:[188,98] width:100 height:16 enabled:true range:[-2000,2000,0]
	label 'med4' "m" pos:[294,98] width:30 height:20
	radiobuttons 'radiodirec' "Direccion:" pos:[175,122] width:97 height:30 enabled:true labels:#("Eje X", "Eje Y") default:1 columns:1
	radiobuttons 'radiosent' "Sentido:" pos:[246,122] width:157 height:30 labels:#("Positivo", "Negativo") columns:1
	
	-- Segundo GroupBox: Viento
	GroupBox 'groupviento' "Viento" pos:[7,183] width:321 height:100
	checkbox 'chkviento' "Aplicar efecto de viento al tiro parabolico" pos:[62,203]
	radiobuttons 'vientodir' "Direccion:" pos:[175,226] width:97 height:30 enabled:false labels:#("Eje X", "Eje Y") default:1 columns:1
	radiobuttons 'vientosen' "Sentido:" pos:[246,226] width:157 height:30 enabled:false labels:#("Positivo", "Negativo") columns:1
	label 'vel2' "Velocidad:" pos:[21,226]
	spinner 'velvien' pos:[21,241] width:100 height:16 enabled:false range:[0,300,0]
	label 'med5' "m/s" pos:[128,241] width:30 height:20
	label 'aviso2' "" pos:[21,258]
	
	-- Tercer GroupBox: Grabaci�n
	GroupBox 'groupgrabacion' "Grabacion" pos:[7,288] width:321 height:138
	button 'camseguimiento' "Camara seguimiento" pos:[21,312] width:140 height:23
	label 'aviso3' "" pos:[42,336]
	pickbutton 'camasociada' "Asociar a camara" pos:[175,312] width:140 height:23
	label 'aviso4' "" pos:[188,336]
	spinner 'movejex' "Mover X:" pos:[53,358] width:100 height:16 enabled:true range:[-1000000,1000000,0]
	spinner 'rotejex' "Rotar X:" pos:[206,358] width:100 height:16 enabled:true type:#integer range:[-360,360,0]
	spinner 'movejey' "Mover Y:" pos:[53,378] width:100 height:16 enabled:true range:[-1000000,1000000,0]
	spinner 'rotejey' "Rotar Y:" pos:[206,378] width:100 height:16 enabled:true type:#integer range:[-360,360,0]
	spinner 'movejez' "Mover Z:" pos:[53,398] width:100 height:16 enabled:true range:[-1000000,1000000,0]
	spinner 'rotejez' "Rotar Z:" pos:[206,398] width:100 height:16 enabled:true type:#integer range:[-360,360,0]
	
	-- Cuarto GroupBox: Color
	GroupBox 'groupcolor' "Color" pos:[7,430] width:321 height:108
	pickbutton 'pickobj' "Selecciona objeto" pos:[25,450] width:130 height:23
	colorPicker 'cp' "Selecciona color" pos:[180,450] width:130 height:23
	materialButton 'materialb' "Selecciona material" pos:[25,480] width:130 height:23
	mapButton 'mapb' "Selecciona mapa" pos:[180,480] width:130 height:23
	spinner 'eligeMaterial' "Aplica mapa al material:" pos:[155,512] width:100 height:16 type:#integer range:[1,24,1]
	
	-- Quinto GroupBox: Otros
	GroupBox 'groupotros' "Otros" pos:[7,542] width:321 height:73
	checkbox 'chkfuego' "Aplicar fuego al objeto" pos:[26,564]
	checkbox 'chkorienta' "Orientar a la trayectoria" pos:[180,564]
	spinner 'spninterpolacion' "Frames Interpolados:" pos:[150,588] width:100 height:16 enabled:true type:#integer range:[1,10,1]
	
	
	
	-- Variables globales
	global dir_viento = "x" as string 			-- Direcci�n del viento
	global sen_viento = "pos" as string 		-- Sentido del viento para una direcci�n
	global direccion = "x" as string 				-- Direcci�n del proyectil
	global sentido = "pos" as string 			-- Sentido del proyectil para una direcci�n
	global cam_pos									-- Toma el valor de posici�n en el momento en el que se crea la Freecamera
	global incremento_rot_x = 0 as float 		-- Incremento de rotaci�n en el eje X
	global aux_x = 0 as float
	global incremento_rot_y = 0 as float		-- Incremento de rotaci�n en el eje Y
	global aux_y = 0 as float
	global incremento_rot_z = 0 as float 		-- Incremento de rotaci�n en el eje Z
	global aux_z = 0 as float
	global incremento_dir = 0 as float			-- Incremento de rotaci�n para orientar el proyectil
	
	
	
	-- Funci�n que aplica el efecto de fuego al objeto
	fn aplicaFuego =
	(
		
		-- Creamos el la GizmoEsfera donde se aplicar� el efecto de fuego
		gizmo = SphereGizmo radius:8.60087 pos:$.pos
		scale gizmo [1,1,1.6]
		move gizmo [0,0,6]
		gizmo.parent = $
		
		-- Modificamos sus par�metros para que se parezca m�s al fuego
		addAtmospheric (Fire_Effect ())
		(getAtmospheric 1).Stretch = 0.5
		(getAtmospheric 1).density = 16
		(getAtmospheric 1).Regularity = 0.1
		(getAtmospheric 1).Flame_Size = 17
		(getAtmospheric 1).Flame_Detail = 5.53
		(getAtmospheric 1).Samples = 27
		(getAtmospheric 1).Inner_Color = color 253 212 67
		(getAtmospheric 1).Outer_Color = color 179 30 30
		(getAtmospheric 1).phase = 70
		(getAtmospheric 1).Drift = 70
	)
	
	
	-- Aplica el mapa escogido al objeto seleccionado
	on mapb picked m do
	(
		environmentmap = m
		mapb.text = classof m as string
		mtl = getmeditmaterial 1
		meditMaterials[eligeMaterial.value] = m
	)
	
	
	-- Aplica el material escogido al objeto seleccionado
	on materialb picked mat do
	(
		if $ != undefined do 
		(
			$.material = mat
		)
	)
	
	
	-- Aplica el color escogido al objeto seleccionado
	on cp changed col do
	(
		$.wirecolor = col
	)
	
	
	-- Selecciona el objeto para cambiar su color
	on pickobj picked sel do
	(
		select sel
		pickobj.text = sel.name
	)
	
	
	-- Funci�n para resetear los valores de los spinners de la c�mara
	fn resetCamera = 
	(
		aux_x = 0
		aux_y = 0
		aux_z = 0
		movejex.value = 0.0
		movejey.value = 0.0
		movejez.value = 0.0
		rotejex.value = 0
		rotejey.value = 0
		rotejez.value = 0
	)
	
	
	-- Funci�n para resetear los valores de los spinners del tiro parab�lico
	fn resetTiro =
	(
		sel.text = "Selecciona"
		vel.value = 30
		ang.value = 45
		grav.value = 9.81
		cai.value = 0
	)
	
	
	-- Rota la Freecamera por el eje Z
	on rotejez changed val do
	(
		if $ == undefined then
		(
			rotejez.value = 0
		)
		else
		(
			incremento_rot_z = val - aux_z
			aux_z = val
			rotate $ (eulerangles 0 0 incremento_rot_z)
		)
	)
	
	
	-- Rota la Freecamera por el eje Y
	on rotejey changed val do
	(
		if $ == undefined then
		(
			rotejey.value = 0
		)
		else
		(
			incremento_rot_y = val - aux_y
			aux_y = val
			rotate $ (eulerangles 0 incremento_rot_y 0)
		)
	)
	
	
	-- Rota la Freecamera por el eje X
	on rotejex changed val do
	(
		if $ == undefined then
		(
			rotejex.value = 0
		)
		else
		(
			incremento_rot_x = val - aux_x
			aux_x = val
			rotate $ (eulerangles incremento_rot_x 0 0)
		)
	)
	
	
	-- Mueve la Freecamera por el eje Z
	on movejez changed val do
	(
		if $ == undefined then
		(
			movejez.value = 0
		)
		else
		(
			$.pos.z = cam_pos.z + val
		)
	)
	
	
	-- Mueve la Freecamera por el eje Y
	on movejey changed val do
	(
		if $ == undefined then
		(
			movejey.value = 0
		)
		else
		(
			$.pos.y = cam_pos.y + val
		)
	)
	
	
	-- Mueve la Freecamera por el eje X
	on movejex changed val do
	(
		if $ == undefined then
		(
			movejex.value = 0
		)
		else
		(
			$.pos.x = cam_pos.x + val
		)
	)
	
	
	-- Asocia mediante un link el target de una c�mara al proyectil
	on camasociada picked cam do
	(
		if $ != undefined then
		(
			aviso3.text = ""
			if cam.target == undefined then
			(
				aviso4.text = "Solo 'Physical' y 'Target'"
				aviso4.pos = [188,336]
			)
			else
			(
				aviso4.text = ""
				camasociada.text = cam.name
				cam.target.parent = $
			)
		)
		else
		(
			
			aviso3.text = "Selecciona un objeto"
			aviso3.pos = [42,336]
		)
	)
	
	
	-- Crea una Freecamera que siga la trayectoria del proyectil en primera persona
	on camseguimiento pressed do
	(
		local camara
		
		if $ == undefined then
		(
			aviso3.text = "Selecciona un objeto"
			aviso3.pos = [42,336]
		)
		else
		(
			aviso3.text = ""
			
			-- Creamos la Freecamera y la posicionamos
			camara = Freecamera pos:$.pos
			camara.parent = $
			rotate camara (eulerangles 90 0 -90)
			
			-- Preparamos los spinners por defecto para posicionar manualmente la nueva c�mara
			cam_pos = camara.pos
			resetCamera()
			select camara
		)
	)
	
	
	--Se activa cuando cambiamos el tick de efecto viento
	on chkviento changed stat3 do 
	(
		if(stat3==0) then
		(
			vientodir.enabled = false
			vientosen.enabled = false
			velvien.enabled = false
		)else(
			vientodir.enabled = true
			vientosen.enabled = true
			velvien.enabled = true
		)
	)
	
	
	-- Toma la direcci�n del viento
	on vientodir changed stat do
	(
		case stat of
		(
			1: dir_viento = "x"
			2: dir_viento = "y"
		)
	)
	
	
	-- Toma el sentido del viento
	on vientosen changed stat do
	(
		case stat of
		(
			1: sen_viento = "pos"
			2: sen_viento = "neg"
		)
	)
	
	
	-- Toma la direcci�n en la que viajar� el proyectil
	on radiodirec changed stat1 do
	(
		case stat1 of
		(
			1: direccion = "x"
			2: direccion = "y"
		)
	)
	
	
	-- Toma el sentido del proyectil para una direcci�n
	on radiosent changed stat2 do
	(
		case stat2 of
		(
			1: sentido = "pos"
			2: sentido = "neg"
		)
	)
		
	
	-- Selecciona el objeto a lanzar
	on sel picked seleccion do
	(
		select seleccion
		sel.text = seleccion.name
		aviso.text = ""
	)
	
	
	-- Restaura los valores por defecto de los par�metros
	on reset1 pressed do
	(
		clearSelection()
		sel.text = "Selecciona"
		resetTiro()
	)
	
	
	-- Borra los keyframes creados para volver a animar
	on borrar pressed do
	(
		proyectil = $
		deletekeys proyectil
	)
		
	
	on disparo pressed do -- Crea animaci�n del tiro parabolico
	( 
		if $ == undefined then
		(
			aviso.text = "Selecciona un objeto"
			aviso.pos = [28,125]
		)
		else
		(
			proyectil = $ 				-- Toma el objeto seleccionado
			velocidad = vel.value 	-- Toma la velocidad
			angulo = ang.value 		-- Toma el �ngulo
			gravedad = grav.value  -- Toma la gravedad
			caida = cai.value			-- Toma la altura a la que cae
			local viento = 0			-- Definimos la variable de la velociad del viento
			local dispara = true
			local vientoPerpen = false
			local primera_rotaci�n = true
			local resta = 0 as float
			local vzsiguiente = 0 as float
			
			-- Vemos si el viento se aplica a favor o en contra
			if chkviento.checked==true do
			(
				viento = velvien.value -- Toma la velocidad del viento
				if dir_viento==direccion then
				(
					if sen_viento==sentido then
					(
						velocidad = velocidad + viento
					)
					else
					(
						if velocidad>viento then
						(
							velocidad = velocidad - viento
						)
						else
						(
							aviso2.text = "Menor que la del objeto"
							aviso2.pos = [21,260]
							dispara = false
						)
					)
				)
				else
				(
					vientoPerpen = true
				)
			)
			
			-- Si el viento aplicado no cambia el sentido de la trayectoria del proyectil
			if dispara==true do
			(
				aviso2.text = ""
				
				-- Comprobamos si aplicamos fuego
				if chkfuego.checked == true do
				(
					aplicaFuego()
				)
				
				-- C�lculos
				veje = velocidad * cos(angulo) as float
				vz = velocidad * sin(angulo) as float
				vzsiguiente = vz
				
				tiempo_vuelo = proyectil.pos.z + ( 2 * vz * sin(angulo)   / gravedad ) as time
				
				-- Toma el frame de incio y calcula el frame final
				fotograma_inicial = (sliderTime as integer)/ticksperframe -- Tick donde empieza la animacion
				fotograma_final = ceil(fotograma_inicial + tiempo_vuelo*20 as float)
				
				-- Toma la posicion inicial del objeto
				local eje_inicial = 0
				if direccion=="x" then
				(
					eje_inicial = proyectil.pos.x
				)
				else
				(
					eje_inicial = proyectil.pos.y
				)
				z_inicial = proyectil.pos.z
				
				-- Par�metros para el movimiento del proyectil con viento en perpendicular
				local eje_viento = 0
				local vviento = 0 as float
				if vientoPerpen==true do
				(
					vviento = viento * cos(angulo)
					if dir_viento=="x" then
					(
						eje_viento = proyectil.pos.x
					)
					else
					(
						eje_viento = proyectil.pos.y
					)
				)
				
				-- Inicia tiempo para el calculo del tiro parabolico
				t0 = 0
				i = 0
				x = 0
				z = 0
				cayendo = false
				
				-- Rutina de la animacion
				animate on for fotograma= fotograma_inicial to  fotograma_final  by spninterpolacion.value do
					at time fotograma
					(
						local z_anterior = z
						local eje = 0 as float
						local desplazamiento = 0 as float
						
						-- Para el sentido del proyectil
						if sentido=="neg" then
						(
							eje = -(eje_inicial + veje * t0) as float
						)
						else
						(
							eje = eje_inicial + veje * t0 as float
						)
						
						-- Para el sentido del viento
						if vientoPerpen==true do
						(
							if sen_viento=="neg" then
							(
								desplazamiento = -(eje_viento + vviento * t0) as float
							)
							else
							(
								desplazamiento = eje_viento + vviento * t0 as float
							)
						)
						
						z = z_inicial + (vz * t0) - (0.5 * gravedad * (t0 ^ 2)) as float 
							
						-- Comprobamos que est� cayendo el proyectil
						if z_anterior>z and z>=caida do
						(
							cayendo = true
						)
						
						-- Comprobamos que ha llegado a la ca�da maxima
						if z<caida and cayendo==true do
						(
							exit
						)
						
						-- Orienta el proyectil a la trayectoria
						if chkorienta.checked == true do
						(
							local angulo2 = atan(vzsiguiente/veje) as float
							vzsiguiente = velocidad * sin(angulo) - gravedad * t0
							incremento_dir = resta - angulo2
							resta = angulo2
							
							if direccion == "x" then
							(
								if sentido == "pos" then
								(
									rotate $ (eulerangles 0 incremento_dir 0)
								)
								else
								(
									rotate $ (eulerangles 0 -incremento_dir 0)
								)
							)
							else
							(
								if sentido == "pos" then
								(e
									rotate $ (eulerangles -incremento_dir 0 0)
								)
								else
								(
									rotate $ (eulerangles incremento_dir 0 0)
								)
							)
						)
						
						-- Situa las posiciones calculadas
						if direccion=="x" then
						(
							if vientoPerpen == true then
							(
								proyectil.pos = [eje, desplazamiento, z]
							)
							else
							(
								proyectil.pos = [eje, proyectil.pos.y, z]
							)
						)
						else
						(
							if vientoPerpen == true then
							(
								proyectil.pos = [desplazamiento, eje, z]
							)
							else
							(
								proyectil.pos = [proyectil.pos.x, eje, z]
							)
						)
						
						-- Incrementamos el tiempo de tal manera que cuando lleguemos al fotograma final t0 = fotogramafinal/frames per second
						
						--t0 = t0 + 1 -- Incrementa el tiempo del calculo
						-- En el frame 1 el tiempo de vuelo sera 0 y en el ultimo frame valdra "tiempo_vuelo"
						t0 = tiempo_vuelo * ( 1 - ((fotograma_final - i)/fotograma_final) )
						i = i + spninterpolacion.value
							
					)
			)
		)
	)
	
	
)
createDialog TiroParabolico