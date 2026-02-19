# Task Manager App
Esta es una aplicación móvil creada por los alumnos del 6to semestre de IDS para el examen parcial de la materia **Desarrollo de Aplicaciones Móviles**.  

El objetivo de permitir al usuario **crear, visualizar, modificar y eliminación de tareas o actividades**.

La aplicación fue construida con:
 - **Flutter** (Front-end)
 - **Node.js** (Back-end con API REST)
 - **Microsoft Server SQL (mssql)** (Base de Datos).
 - **Visual Studio Code (VS Code)** como IDE principal.


## Ejecución

### Back-end

### Instalación
Esta back-end esta construido en Node.js, framework de javascript para la creación y gestión de servidores. 

1. Inicializar proyecto:
```bash
npm init -y
```

2. Instalación de dependencias

 - express (comunicación http).
 - mssql (base de datos SQL).
 - nodemon (persistencia y reinicio de Node). 
 
 Para instalar estas dependecias, ejecute el siguiente comando en la terminal del IDE.
```bash
npm i express mssql nodemon -D
```

3. Configuración de base de datos

Para poder conectar el back-end a la base de datos, dirijase al archivo en la ruta  `backend/src/config.js`. Ingrese al archivo y modifique los datos de la configuración con los datos referentes a su base de datos.
  

```bask
const dbconfig = { 
    "user": "sa", // Database username
    "password": "passwordDB", // Database password
    "server": "localhost", // Server IP address 
    "database": "Taskexpress", // Database name
    "options": {
        "encrypt": false, // Disable encryption
    },
} 
```

4. Ejecución del programa

Para ejecutar o correr el back-end Node ejecute el siguiente comando en la terminal del IDE.

```bash
npm run dev
```

Al ejecutar dicho comando, se mostrarán en la terminal los siguientes mesajes que indican que la conexión a la base de datos es exitosa.

```bash
Connected to SQL Server!
API listening in http://localhost:3010
```
---
### Front-end
Flutter necesita el paquete o despendecia `http`, el cual permite la comunicación con el backend por medio de este protocolo. Para instalarlo, ingrese a la carpeta del front-end y ejecute el siguiente comando en la terminal del IDE.

``` bash
flutter pub add http
```

y agregarlo en el archivo `pubspec.yaml`.

```yaml

dependencies:
    flutter:
        sdk: flutter
    http: ^1.6.0
```

Para ejecutar el front-end en Flutter debe usarse un emulador o un telefono móvil físico. Es recomendada la segunda opción por la dirección de IPs y mejor manejo de la interfaz. Conecte el móvil a la computadora por medio de un cable, seleccione el dispositivo en donde el proyecto será ejecutado y presione F5 o en la opción de "ejecutar" del IDE. Tardará un momento en compilarse e instalarse la aplicación. Cuando la aplicación este totalmente instalada puede desconectar el cable y probar la conectividad del móvil con el back-end. 

## Consultas
Las consultas fueron probadas por medio del cliente HTTP Thunder Client. Las consultas permiten la visualización de todas las tareas, creación, actualización y eliminación de tareas específicas.

Nota: Tomar en cuenta que `id` y `isDone` son números enteros.


**Lista de las direcciones y métodos HTTP utilizados.**

* **Lista de tareas
 (GET):**  ` http://localhost:3010/api/tasks ` 

* **Dividir si las tareas si estan:**
    * No completados: ` http://localhost:3010/api/tasks/recurring`  
    * Completados: ` http://localhost:3010/api/tasks/completed`  



* **Creación de tarea (POST):**  ` http://localhost:3010/api/tasks 
id" `  y  ` isDone `  son números enteros.

* **Lista de tareas (GET):**  ` http://localhost:3010/api/tasks ` 


* **Creación de tarea (POST):** ` http://localhost:3010/api/tasks ` 

* **Actualización de isDone de tarea (PUT):**  ` http://localhost:3010/api/tasks/id/isDone `  

* **Eliminación de tarea (DELETE):**  ` http://localhost:3010/api/tasks/id ` 




 
Para crear una tarea debe utilizarse el forma json presentado. Tengase en cuenta que  ` priority `  tiene las opcioens  ` High ` ,  ` Medium ` ,  ` Low ` ; tambíen que  ` status ` puede ser  ` Pending ` ,  ` In Progress ` ,  ` Completed ` ,  ` Canceled `, `In Progress`, `Completed`, `Canceled`; y por último `recurringTast` o `isDone` puede ser 0 o 1. 

```javascript
{
    "title": "titulo",
    "description": "descripción",
    "dueDate": "02-18-2026",
    "priority": "High",
    "status": "In Progress",
    "recurringTask": 0
}

```

## Evidencias
captura de 3 tareas
creación de tarea 
tarea marcada como hecha


---

## Evidencias visuales

- En la primer imagen se muestra el ingreso de los atributos de una tarea
- En la imagen dos muestra se muestran las tareas agregadas.
- Tercer imagen se observa la eliminación de una tarea.

  
![Imagen 1: Ingreso de una tarea.](images/image1.jpeg)

![Imagen 2: Creación o agregación de una tarea.](images/image2.jpeg)

![Imagen 3: Eliminación de una tarea.](images/image3.jpeg)
