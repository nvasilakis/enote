# We define the minimum cmake. This is standard for Elementary OS
cmake_minimum_required (VERSION 2.8)
#We define the minimum policy version
cmake_policy(VERSION 2.8)
#We define out project name.
project(enote)
set (EXEC_NAME "enote")

#Here we load the modules we downloaded earlier and placed into the ./cmake directory
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )

#Here we're including the Vala package from ../cmake
find_package(Vala REQUIRED)
#Now we're including the version module to ensure we have a compatible version
include(ValaVersion)
ensure_vala_version("0.11.3" MINIMUM)
#Now we're including the precompile modules to set things up.
include(ValaPrecompile)

#We're going to load the PkgConfig module from ../cmake
#We do this to ensure we can include required modules.
#PkgConfig handles all of the querying of packages for us.
#It finds their directories, versions, and if they're installed.
find_package(PkgConfig)

#Now we're declaring GTK+ 3 and Granite as our REQUIRE dependancies.
#If PkgConfig can't find these, you need to install them in Step 1.
pkg_check_modules(DEPS REQUIRED gtk+-3.0 granite glib-2.0 libnotify)

#Now we're going to ready the libraries and get their directories to include them.
set(CFLAGS
    ${DEPS_CFLAGS} ${DEPS_CFLAGS_OTHER}
)
set(LIB_PATHS
    ${DEPS_LIBRARY_DIRS}
)
link_directories(${LIB_PATHS})

#Here is where vala precompiles all the *.vala files into *.c files.
#Then we compule the *.c files to turn them into a true executable.
add_definitions(${CFLAGS})
vala_precompile(VALA_C #${EXEC_NAME}
    src/main.vala
    src/View.vala
    src/Window.vala
    src/Welcome.vala
    src/TaskList.vala
    src/Utils.vala
    src/NewTask.vala
    src/Task.vala
    src/RecordView.vala
PACKAGES
    gtk+-3.0
    granite
    glib-2.0
    libnotify
OPTIONS
    --thread)

include(GSettings)
add_schema("schema/org.pantheon.enote.gschema.xml")

#Here we define our executable name.
add_executable(enote
    ${VALA_C} )

#We need to link the libraries with our Executable.
target_link_libraries(enote ${DEPS_LIBRARIES})
