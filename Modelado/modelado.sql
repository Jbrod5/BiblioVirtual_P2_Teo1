Membresia
    id_membresia ingeter
    nombre string
    descuento double/integer
    precio double
    -- plata 5%, oro 7%, diamante 10%

insignia
    id_insignia INTEGER PK
    nombre string
    descripcion text

Rol_usuario
    id_rol integer
    nombre string
    -- administrador, cliente, moderador? (o sus funciones pueden ser de admin?), autor, un cliente normal es tambien autor????

Usuario 
    username pk string
    nombre string
    contraseña string 
    2fa boolean -- para indicar si tiene doble factor de autenticacion 

    rol integer REFERENCES Rol_usuario
    activo boolean -- para no borrar los ussuariossss


    saldo double
    puntos integer

    --insignia -- Puede ser una o varias????
    --membresia
    aprobado_autor boolean -- el admin puede aprobarlo para subir publicaciones
    precio_suscripcion double -- cada autor debe decidir cuanto cuesta su suscripcion?????


usuario_membresia -- lista de todas las membresias :3
    id
    usuario REFERENCES Usuario(username)
    membresia REFERENCES Membresia(id_membresia)
    inicio timestamp
    fin timestamp

usuario_insignia -- un usuario puede tener una o más insignias :3
    insignia REFERENCES insignia(id_insignia)
    usuario REFERENCES usuario(username)
--suscripcion_cliente_autor
--    id_suscripcion
--    cliente REFERENCES Usuario(username)
--    autor REFERENCES Usuario(username)
--    fecha_inicio timestamp
--    fecha_fin timestamp





Transaccion -- historial de transacciones, sirve tanto para saldo como puntos :3
    usuario REFERENCES Usuario(username)
    puntos boolean --verdadero si son puntos, falso si es saldo

    cantidad_transaccion double -- positivo si se ingresa, negativo si se egresa, pueden ser puntos ooooo dinero
    tarjeta REFERENCES Tarjetas(tarjeta) -- puede ser nulo :3
    descripcion text -- es una descripcion de la transaccion :3
    fecha timestamp

Ingreso_plataforma
    id_ingreso
    usuario REFERENCES Usuario(username)
    fecha timestamp
    descripcion text
    ingreso double


Tarjetas -- lista de tarjetas que tienen los usuarios
    usuario REFERENCES Usuario(username)
    tarjeta integer 

Notificaciones 
    usuario REFERENCES Usuario(username)
    titulo_notificacion text -- para indicar 
    cuerpo_notificacion text -- expande la info de la notificacion :3


Suscripciones
    id_suscripcion
    cliente REFERENCES Usuario(username)
    autor REFERENCES Usuario(username)
    fecha_inicio timestamp
    fecha_fin timestamp






Estado_publicacion
    id_estado
    nombre
    descripcion
    -- aprobado, rechazado, retirado

Categoria_publicacion
    id_categoria
    nombre string
    descripcion text 

Publicacion
    id_publicacion INTEGER PK
    publica boolean

    titulo string
    descripcion string
    categoria REFERENCES Categoria_publicacion(id_categoria) -- puede ser ciencia, arte, opinion :3 
    contenido text -- Esto mmm puede/debe ser un pdf, documento, etc??? que quede como texto temporalmente
    url_archivo string -- url al archivo pdf, doc o lo que sea que se necesite si se necesita xd puede ser null
    fecha_publicacion timestamp

    precio_saldo
    precio_puntos -- No es fijo, se calcula por la extension y calidad????
    autor REFERENCES Usuario(username)

    estado REFERENCES Estado_publicacion(id_estado)

    cantidad_reportes INTEGER -- es necesario controlarlo aquí??
    calificacion_general double -- promedio de todas las calificaciones
    cantidad_compras integer -- cantidad de veces que se compro la publicacion  

Publicaciones_compradas --para saber que publicaciones ha comprado un usuario y saber si tiene acceso a ellas o no :3
    usuario REFERENCES Usuario(username)
    publicacion REFERENCES Publicacion(id_publicacion)
   


Reseña_publicacion
    -- Un usuario solo puede dejar una reseña? si si, entonces pk = usuario + id pub
    publicacion REFERENCES Publicacion(id_publicacion)
    usuario REFERENCES Usuario(username)
    calificacion INTEGER
    reseña text
    fecha timestamp

    

Reporte_publicacion
    publicacion REFERENCES Publicacion(id_publicacion)
    usuario REFERENCES Usuario(username)
    descripcion TEXT
    fecha timestamp
