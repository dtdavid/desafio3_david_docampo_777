--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.
-- creación de la base de datos:
create database desafio3_david_docampo_777;
--creación de la tabla "usuarios":
create table usuarios(
id serial,
email varchar(25),
nombre varchar(25),
apellido varchar(25),
rol varchar(10)
);
--insertar 5 registros en la tabla "usuarios"
insert into usuarios (email, nombre, apellido, rol) values (
    'juan.rodriguez@gmail.com', 'Juan', 'Rodríguez', 'administrador'
);
insert into usuarios (email, nombre, apellido, rol) values (
    'sofia.gonzalez@gmail.com', 'Sofía', 'González', 'usuario'
);
insert into usuarios (email, nombre, apellido, rol) values (
    'pedro.salazar@gmail.com', 'Pedro', 'Salazar', 'usuario'
);
insert into usuarios (email, nombre, apellido, rol) values (
    'julian.seijas@gmail.com', 'Julian', 'Seijas', 'usuario'
);
insert into usuarios (email, nombre, apellido, rol) values (
    'teresa.vazquez@gmail.com', 'Teresa', 'Vázquez', 'usuario'
);
--creación de la tabla "posts"
create table posts(
    id serial,
    titulo varchar,
    contenido text,
    fecha_creacion timestamp,
    fecha_actualizacion timestamp,
    destacado boolean,
    usuario_id bigint
);
--inserción de 5 registros en la tabla "posts"
insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values (
    'Ordenadores', 'Los mas rápidos del 2023', '2023-10-22', '2023-12-09', TRUE, 1 
);
insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values (
    'Libros', 'Los mas vendidos del 2022', '2022-06-22', '2023-07-09', TRUE, 1 
);
insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values (
    'Sábanas', 'Las mas resistentes', '2020-10-03', '2023-09-09', TRUE, 2 
);
insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values (
    'Almohadas', 'Tendencia 2022', '2022-01-12', '2024-07-09', FALSE, 3 
);
insert into posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) values (
    'Coches eléctricos', 'Nueva guía', '2024-01-12', '2024-08-09', TRUE, null 
);
--creación de la tabla "comentarios":
create table comentarios(
    id serial,
    contenido varchar(100),
    fecha_creacion timestamp,
    usuario_id bigint,
    post_id bigint
);
--inserción de 5 registros en la tabla "comentarios":
insert into comentarios(contenido, fecha_creacion, usuario_id, post_id) values ('Muy bueno', '2023-11-06', 1, 1);
insert into comentarios(contenido, fecha_creacion, usuario_id, post_id) values ('Interesante', '2023-11-08', 2, 1);
insert into comentarios(contenido, fecha_creacion, usuario_id, post_id) values ('Tomo nota', '2023-11-21', 3, 1);
insert into comentarios(contenido, fecha_creacion, usuario_id, post_id) values ('Muchas páginas', '2023-10-10', 1, 2);
insert into comentarios(contenido, fecha_creacion, usuario_id, post_id) values ('Está interesante', '2023-11-01', 2, 2);

--##CONSULTAS##

--2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

select nombre, email, titulo, contenido from usuarios u join posts p on
 u.id = p.usuario_id;

--3. Muestra el id, título y contenido de los posts de los administradores.
--a. El administrador puede ser cualquier id.

select u.id, p.titulo, p.contenido from posts p join usuarios u on
 p.usuario_id = u.id where u.rol = 'administrador';

--4. Cuenta la cantidad de posts de cada usuario.
--a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.

select u.id, u.email, count(p.titulo) as cantidad_post from usuarios u
 left join posts p on u.id = p.usuario_id group by u.id, u.email;

--5. Muestra el email del usuario que ha creado más posts.
--a. Aquí la tabla resultante tiene un único registro y muestra solo el email.

select email from usuarios u join posts p on u.id = p.usuario_id group by
 email order by count(u.id) desc limit 1;

--6. Muestra la fecha del último post de cada usuario. Hint: Utiliza la función de agregado MAX sobre la fecha de creación.

select u.nombre, max(p.fecha_creacion) as post_reciente from
usuarios u join posts p on u.id = p.usuario_id group by u.nombre;

--7. Muestra el título y contenido del post (artículo) con más comentarios.

select p.titulo, p.contenido as mas_comentarios from posts p join comentarios c on p.id = c.post_id group by p.titulo, p.contenido;
 -- r

--8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

select p.titulo, p.contenido, c.contenido, u.email from posts p inner join
 comentarios c on p.id = c.post_id inner join usuarios u on c.usuario_id = u.id;
 --r

--9. Muestra el contenido del último comentario de cada usuario.

select u.nombre, u.apellido, c.contenido from usuarios u join comentarios c on
u.id = c.usuario_id where c.fecha_creacion = (select max(c.fecha_creacion) from
 comentarios c where u.id = c.usuario_id);

--10. Muestra los emails de los usuarios que no han escrito ningún comentario. Hint: Recuerda el uso de Having.

select u.email from usuarios u left join
comentarios c on u.id = c.usuario_id group by
 u.email  having count(c.id) = 0;
