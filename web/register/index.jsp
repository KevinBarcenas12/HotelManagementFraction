<%-- 
    Document   : /register/
    Created on : Dec 2, 2021, 12:01:38 AM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="backend.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="description" content="Registrate en el mejor sitio hotelero!">
        <link rel="stylesheet" href="<%= application.getContextPath() %>/styles.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
        <title>Registrate</title>
    </head>
    <%if (session.getAttribute(Attributes.UserId) != null) {
        %><script>window.location.href="<%= application.getContextPath() %>/home/"</script><%
    }%>
    <style>
        .font-poppins {
            font-family: 'Poppins', sans-serif;
        }
        img.background {
            width: auto;
            height: 100%;
            min-width: 100%;
            min-height: 100%;
            max-width: unset;
            max-height: unset;
            position: absolute;
            overflow: hidden;
        }
        ::-webkit-scrollbar {
            width: 0;
            height: 0;
        }
        input[type], button {
            border: none;
            outline: none;
            transition: 250ms;
        }
        input[type]:invalid {
            background: #f9aaaa;
        }
        input[type]:invalid:placeholder-shown {
            background: white !important;
        }
        input[type]:valid {
            background: #aaf9aa;
        }
        input[type]:valid:placeholder-shown {
            background: white !important;
        }
        input[type="radio"]:checked + label[for] {
            color: hsl(200, 100%, 75%);
        }
        input[type="radio"]:checked + label[for]::after {
            width: 100%;
        }
        input[type="radio"] + label[for] {
            position: relative;
        }
        input[type="radio"] + label[for]::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            bottom: 0;
            width: 0;
            height: .125rem;
            background: hsl(200, 100%, 75%);
            transition: 500ms ease;
        }
        video {
            width: auto;
            height: auto;
            min-width: 100% !important;
            min-height: 100% !important;
            max-width: unset !important;
            max-height: unset !important;
            aspect-ratio: 16/9;
        }
    </style>
    <body>
        <div class="w-full h-full bg-red-400 overflow-hidden flex flex-col items-center justify-center">
            <%-- Container --%>
            <img src="<%= application.getContextPath() %>/images/img-video-home-poster.jpg" class="background" >
            <%-- Content --%>
            <div
                class="w-full h-full select-none flex flex-row items-center justify-center backdrop-filter backdrop-blur-lg"
                style="z-index: 2;"
            >
                <div class="h-full lg:h-2/3 w-full lg:w-3/4 flex flex-row items-center justify-center relative">
                    <div
                        class="content w-full lg:w-2/3 xl:w-1/2 2xl:w-1/4 h-full flex flex-col items-center justify-center lg:rounded-3xl z-20 relative"
                        style="background: #134e4a"
                    >
                        <%-- Register Form --%>
                        <span class="font-poppins text-2xl text-blue-300">
                            Datos Personales:
                        </span>
                        <%
                            String formResult = null;
                            if (session.getAttribute(Attributes.FormResult) != null) {
                                formResult = session.getAttribute(Attributes.FormResult).toString();
                            }
                        %>
                        <form action="<%= application.getContextPath() %>/auth.jsp" method="POST" autocomplete="off" class="grid grid-cols-4 gap-1 place-items-center w-10/12">
                            <input
                                type="hidden"
                                name="<%= Attributes.FormType %>"
                                value="<%= Form.Type.Register %>"
                            >
                            <%-- First Name --%>
                            <span class="font-poppins self-center col-span-4 lg:col-span-2 text-left place-self-start text-white">
                                Primer Nombre:
                            </span>
                            <input
                                type="text"
                                name="<%= Form.Register.FirstName %>"
                                placeholder="Nombre"
                                pattern="[A-Za-z0-9]{3,}"
                                class="w-full col-span-4 lg:col-span-2 text-left px-2 py-3 rounded-lg"
                                required
                            >
                            <%-- Last Name --%>
                            <span class="font-poppins self-center col-span-4 lg:col-span-2 text-left place-self-start text-white">
                                Primer Apellido:
                            </span>
                            <input
                                type="text"
                                name="<%= Form.Register.LastName %>"
                                placeholder="Apellido"
                                pattern="[A-Za-z0-9]{3,}"
                                class="w-full col-span-4 lg:col-span-2 text-left px-2 py-3 rounded-lg"
                                required
                            >
                            <span class="font-poppins self-center col-span-4 lg:col-span-1 text-left place-self-start text-white">
                                Correo:
                            </span>
                            <input
                                type="email"
                                name="<%= Form.Register.Email %>"
                                placeholder="Correo electrónico"
                                pattern="[A-Za-z0-9.]{4,}+@[a-z]{1,}+\.[a-z]{2,4}$"
                                class="w-full col-span-4 lg:col-span-3 text-left px-2 py-3 rounded-lg"
                                required
                            >
                            <%-- Gender --%>
                            <div class="col-span-4 grid grid-cols-4 gap-1 w-full text-white py-2" >
                                <span class="font-poppins self-center text-left place-self-start">
                                    Genero:
                                </span>
                                <div class="col-span-3 flex flex-row justify-evenly">
                                    <input
                                        type="radio"
                                        name="<%= Form.Register.Gender %>"
                                        id="male"
                                        value="male"
                                        required
                                        hidden
                                    >
                                    <label for="male" class="font-poppins transition duration-300">
                                        Hombre
                                    </label>
                                    <input
                                        type="radio"
                                        name="<%= Form.Register.Gender %>"
                                        id="female"
                                        value="female"
                                        hidden
                                        required
                                    >
                                    <label for="female" class="font-poppins transition duration-300">
                                        Mujer
                                    </label>
                                    <input
                                        type="radio"
                                        name="<%= Form.Register.Gender %>"
                                        id="other"
                                        value="other"
                                        hidden
                                        required
                                    >
                                    <label for="other" class="font-poppins transition duration-300">
                                        Otro
                                    </label>
                                </div>
                                <%-- / Gender --%>
                            </div>
                            <span class="font-poppins self-center text-left place-self-start text-white">
                                Edad:
                            </span>
                            <input
                                type="number"
                                name="<%= Form.Register.Age %>"
                                placeholder="Edad"
                                required
                                class="w-full col-span-4 lg:col-span-3 text-left px-2 py-3 rounded-lg text-black"
                            >
                            
                            <%if (formResult == null) { %>
                            <span class="font-poppins text-xl text-black">

                            </span>
                            <%} else if (formResult == Form.Result.FormError) {%>
                            <span class="font-poppins text-xl text-black">
                                Parametros incorrectos
                            </span>
                            <%} else if (formResult == Form.Result.DatabaseConnectionError) {%>
                            <span class="font-poppins text-xl text-black">
                                Error al conectar a la base de datos
                            </span>
                            <%} else if (formResult == Form.Result.InvalidEmail) {%>
                            <span class="font-poppins text-xl text-black">
                                Ese correo ya existe! <a href="<%= application.getContextPath() %>/login/" class="text-purple-500">Inicia sesion</a>
                            </span>
                            <%} else if (formResult == Form.Result.DatabaseError) {%>
                            <span class="font-poppins text-xl text-black">
                                Hubo un error en la base de datos<br>
                                Intenta mas tarde
                            </span>
                            <%}%>
                            <button
                                type="submit"
                                class="font-poppins transition duration-300 col-span-4 hover:bg-white w-1/2 rounded-xl self-center p-2 place-self-center text-black"
                                style="background: hsl(0, 0%, 100%, 65%)"
                            >
                                Registrarse
                            </button>
                        </form>
                        <%-- / Login Form --%>
                    </div>
                    
                    <%-- Media --%>
                    <div class="w-none lg:w-3/4 h-full relative flex items-center justify-center z-10 overflow-hidden rounded-xl transform -translate-x-10 translate-y-5">
                        <video autoplay loop muted class="absolute">
                            <source src="<%= application.getContextPath() %>/images/video-home.mp4" />
                        </video>
                    </div>
                    <%-- / Media --%>
                </div>
                <%-- / Content --%>
            </div>
            <%-- / Container --%>
        </div>
    </body>
</html>
