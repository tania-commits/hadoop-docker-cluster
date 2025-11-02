# Clúster Hadoop con Docker

Este repositorio contiene un clúster Hadoop pseudo-distribuido usando **Docker** y **Docker Compose**. Incluye:

* `Dockerfile` para construir la imagen de Hadoop.
* `docker-compose.yml` para levantar los servicios NameNode, DataNode, ResourceManager y NodeManager.
* Carpeta `conf/` con la configuración XML de Hadoop (`core-site.xml`, `hdfs-site.xml`, `mapred-site.xml`, `yarn-site.xml`).
* Script `start-dfs.sh` para inicializar el NameNode.

---

## Requisitos

* Docker y Docker Compose instalados en tu máquina.
* Sistema operativo compatible (Linux, Windows con WSL2 o MacOS).
* Git para clonar o actualizar el repositorio.

---

## Construcción de la imagen

En la raíz del proyecto:

```bash
docker build -t myhadoop:3.4.2 .
```

Esto creará la imagen `myhadoop:3.4.2` con Hadoop instalado y configurado.

---

## Levantar el clúster

Usando Docker Compose:

```bash
docker-compose up -d
```

Esto arrancará los contenedores:

* `namenode` → HDFS NameNode
* `datanode` → HDFS DataNode
* `resourcemanager` → YARN ResourceManager
* `nodemanager` → YARN NodeManager

---

## Comprobar servicios

* **Interface web del NameNode:** [http://localhost:9870](http://localhost:9870)
* **Interface web del ResourceManager:** [http://localhost:8088](http://localhost:8088)

---

## Comandos básicos dentro del NameNode

Para acceder al contenedor del NameNode:

```bash
docker exec -it namenode bash
```

Dentro del contenedor, puedes probar HDFS:

```bash
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hadoop
echo "hola" > ola.txt
hdfs dfs -put ola.txt
hdfs dfs -ls /user/hadoop
```

---

## Persistencia

Los datos del NameNode y DataNode están en volúmenes persistentes:

* `namenode_data` → `/home/hadoop/namenode`
* `datanode_data` → `/home/hadoop/datanode`

Para comprobar la persistencia:

```bash
docker-compose down
docker-compose up -d
docker exec namenode hdfs dfs -ls /user/hadoop
```

---

## Parar el clúster

```bash
docker-compose down
```

Esto detiene todos los contenedores.

---

## Estructura del proyecto

```
simple-hadoop-cluster/
│
├── Dockerfile
├── docker-compose.yml
├── start-dfs.sh
├── conf/
│   ├── core-site.xml
│   ├── hdfs-site.xml
│   ├── mapred-site.xml
│   └── yarn-site.xml
└── README.md
```

---

## Autor

👩‍💻 Tania Paz – [GitHub](https://github.com/tania-commits)

---

## Notas

* El clúster está configurado para un solo nodo de prueba (pseudo-distribuido), útil para aprendizaje y pruebas.
* Se ha configurado SSH sin contraseña para comunicación entre contenedores.
* Hadoop está configurado para YARN como framework de ejecución de MapReduce.

---

## Comandos de Git para subir el proyecto

Abre PowerShell en la raíz del proyecto y ejecuta:

```powershell
# Inicializar git si no lo está
git init

# Asegurarse de que el remoto apunta al repo correcto
git remote set-url origin https://github.com/tania-commits/hadoop-docker-cluster.git

# Añadir todos los archivos
git add .

# Hacer commit
git commit -m "Proyecto completo: Clúster Hadoop con Docker, Dockerfile, docker-compose y configuración"

# Asegurar que la rama principal se llama main
git branch -M main

# Subir al repositorio remoto
git push -u origin main
```
