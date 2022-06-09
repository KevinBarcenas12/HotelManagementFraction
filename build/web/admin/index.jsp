<%-- 
    Document   : /admin/
    Created on : Dec 14, 2021, 10:55:45 PM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="backend.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="<%= application.getContextPath() %>/styles.css" >
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
        <title>Admin Site</title>
    </head>
    <style>
        .font-poppins {
            font-family: 'Poppins', sans-serif;
        }
        ::-webkit-scrollbar {
            width: .25rem;
        }
        :focus {
            outline: none;
        }
        [disabled] {
            background: #666 !important;
            cursor: not-allowed;
        }
    </style>
    <%
        if (session.getAttribute(Attributes.RequestResult) != null) {
            %><script>console.log("<%= session.getAttribute(Attributes.RequestResult).toString() %>");</script><%
        }
        if (session.getAttribute(Attributes.UserId) == null) {
            session.setAttribute(Attributes.FormResult, Form.Result.UserNotFound);
            %><script>window.location.href = "<%= application.getContextPath() %>/"</script><%
        }
        Database database = new Database(application.getRealPath("/") + "hotel-database");
        boolean isConn = database.connect(), userIsAdmin = false;

        int userLevel = 0;
        
        String FirstName = null, LastName = null, Age = null, Gender = null;
        ResultSet rooms = null, employee = null, clients = null, hotel_info = null;
        
        if (!isConn) {
            session.setAttribute(Attributes.FormResult, Form.Result.DatabaseConnectionError);
            %><script>window.location.href = "<%= application.getContextPath() %>/"</script><%
        }
        else {
            String UserId = session.getAttribute(Attributes.UserId).toString();
            database.query.execute("select first_name, last_name, age, gender, admin_level from employee where user_id = " + UserId);
            ResultSet rs = database.query.getResultSet();
            if (!rs.next()) {
                session.setAttribute(Attributes.FormResult, Form.Result.UserNotFound);
                %><script>window.location.href = "<%= application.getContextPath() %>/"</script><%
            }
            else {
                FirstName = rs.getString(1);
                LastName = rs.getString(2);
                Age = rs.getString(3);
                Gender = rs.getString(4);
                userLevel = rs.getInt(5);
                database.query.execute("select room_number, room_type, max_people, price, discount_percent from rooms order by price, room_number asc");
                rooms = database.query.getResultSet();
                database.query.execute("select first_name, last_name, admin_level, age, user_id from employee where not user_id = " + UserId + " order by admin_level desc");
                employee = database.query.getResultSet();
                database.query.execute("select first_name, last_name, email, age, username, user_id from client");
                clients = database.query.getResultSet();
                database.query.execute("select hotel_name, mision, vision, phone, modified from hotel_info");
                hotel_info = database.query.getResultSet();
                userIsAdmin = session.getAttribute(Attributes.UserType).toString().matches(User.Type.Admin);
            }
        }
    %>
    <body class="grid grid-cols-4 lg:grid-cols-8 xl:grid-cols-12 h-auto xl:h-full">
        <section class="lg:col-span-2 xl:row-span-2 xl:col-span-2 overflow-hidden w-full h-30 flex flex-col items-center justify-center p-5"><!-- User info --> 
            <span><%= FirstName %> <%= LastName %> <%if (userIsAdmin) {%>(Admin)<%}%></span>
            <span><%= Gender %> de <%= Age %> años de edad</span><br>
            <span class="p-2 bg-blue-600 text-white font-black rounded-xl">Revisar el <a class="text-purple-300" href="<%= application.getContextPath() %>/history/">Historial de eventos</a></span>
        </section>
        <section class="col-span-3 lg:col-span-6 xl:col-span-10 xl:row-span-2 overflow-hidden min-h-min w-full p-5 flex flex-col items-center"><!-- Hotel Info -->
            <div class="p-2 rounded-xl w-full mb-1 grid grid-cols-5 place-items-center text-white font-black text-lg" style="background: #701a75">
                <span>Nombre</span>
                <span>Mision</span>
                <span>Vision</span>
                <span>Telefono</span>
                <span>Modificado</span>
            </div>
            <div class="flex flex-col relative h-full w-full overflow-y-scroll select-none py-2">
                <%while (hotel_info.next()) {%>
                <div class="w-full shadow-md hover:shadow-lg my-1 rounded-xl ring-1 ring-blue-4">
                    <div class="w-full grid grid-cols-5 place-items-center p-2 my-1 overflow-hidden">
                        <span><%= hotel_info.getString(1) %></span>
                        <span class="truncate w-full"><%= hotel_info.getString(2) %></span>
                        <span class="truncate w-full"><%= hotel_info.getString(3) %></span>
                        <span><%= hotel_info.getString(4) %></span>
                        <span><%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(hotel_info.getDate(5)) %></span>
                    </div>
                </div>
                <%}%>
                <div class="w-full shadow-md hover:shadow-lg my-1 rounded-xl bg-red-100">
                    <form
                        action="<%= application.getContextPath() %>/request-handler.jsp"
                        method="POST"
                        class="w-full grid grid-cols-2 lg:grid-cols-5 place-items-center p-2 my-1 gap-2"
                    >
                        <div class="grid grid-cols-3">
                            <span class="col-span-1 text-right mr-1">Nombre:</span>
                            <input
                                class="col-span-2 rounded-lg bg-white text-black px-2 font-poppins focus:ring ring-blue-300 transition-all duration-500"
                                type="text"
                                pattern="[A-Za-z0-9 ',\-@]{5,}"
                                name="<%= Request.Element.Info.Name %>"
                                required
                            />
                        </div>
                        <div class="grid grid-cols-3">
                            <span class="col-span-1 text-right mr-1">Mision:</span>
                            <input
                                class="col-span-2 rounded-lg bg-white text-black px-2 font-poppins focus:ring ring-blue-300 transition-all duration-500"
                                name="<%= Request.Element.Info.Mision %>"
                                pattern="[A-Za-z0-9 ',\-@\.]{10,}"
                                required
                            />
                        </div>
                        <div class="grid grid-cols-3">
                            <span class="col-span-1 text-right mr-1">Vision:</span>
                            <input
                                class="col-span-2 rounded-lg bg-white text-black px-2 font-poppins focus:ring ring-blue-300 transition-all duration-500"
                                name="<%= Request.Element.Info.Vision %>"
                                pattern="[A-Za-z0-9 ',\-@\.]{10,}"
                                required
                            />
                        </div>
                        <div class="grid grid-cols-3">
                            <span class="col-span-1 text-right mr-1">Telefono:</span>
                            <input
                                class="col-span-2 rounded-lg bg-white text-black px-2 font-poppins focus:ring ring-blue-300 transition-all duration-500"
                                type="text"
                                pattern="[A-Za-z0-9]{8,11}"
                                name="<%= Request.Element.Info.Phone %>"
                                required
                            />
                        </div>
                        <div class="col-span-2 lg:col-span-1">
                            <button type="submit" class="place-self-end rounded-xl bg-blue-200 px-5 py-1">Guardar</button>
                        </div>
                        <input
                            type="hidden"
                            name="<%= Request.Attributes.Command %>"
                            value="insert into hotel_info (hotel_name, mision, vision, phone, modified) values('%<%= Request.Element.Info.Name %>%', '%<%= Request.Element.Info.Mision %>%', '%<%= Request.Element.Info.Vision %>%', '%<%= Request.Element.Info.Phone %>%', #%<%= Request.Element.Info.Date %>%#)"
                        >
                        <input
                            type="hidden"
                            name="<%= Request.Attributes.Type %>"
                            value="<%= Request.Type.InfoModify %>"
                        >
                    </form>
                </div>
            </div>
        </section>
        <section class="col-span-4 lg:col-span-8 xl:col-span-8 xl:row-span-6 overflow-hidden min-h-min w-full p-5 flex flex-col " style="max-height: 70vh"><!-- Rooms Info -->
            <div class="p-2 rounded-xl w-full mb-1 grid grid-cols-5 place-items-center text-white font-black text-lg" style="background: #701a75">
                <span>Habitacion</span>
                <span>Tipo</span>
                <span class="truncate w-full">Capacidad maxima</span>
                <span>Precio</span>
                <span>Descuento</span>
            </div>
            <div class="flex flex-col relative h-full w-full overflow-y-scroll select-none px-2">
                <%-- Contenido --%>
                <% while (rooms.next()) { %>
                <div class="w-full shadow-md hover:shadow-lg rounded-xl ring-1 ring-blue-4 my-1">
                    <div class="w-full grid grid-cols-5 place-items-center p-2 my-1 clickListener">
                        <span>Numero <%= rooms.getInt(1) %></span>
                        <span><%= rooms.getString(2) %></span>
                        <span><%= rooms.getInt(3) %> personas</span>
                        <span><%= rooms.getInt(4) %>L.</span>
                        <span><%= rooms.getInt(5) %>%</span>
                    </div>
                    <div class="h-0 w-full bg-red-100 overflow-hidden rounded-b-xl">
                        <form
                            method="POST"
                            action="<%= application.getContextPath() %>/request-handler.jsp"
                            class="grid grid-cols-6 lg:grid-cols-12 grid-rows-6 lg:grid-rows-3 p-1 h-40 lg:h-20 gap-2"
                        >
                            <div class="col-span-3 row-span-3 grid grid-cols-1 grid-rows-2" >
                                <span class="text-black font-poppins text-xl font-bold">Capacidad</span>
                                <input
                                    type="number"
                                    name="<%= Request.Element.Room.Capacity %>"
                                    value="<%= rooms.getInt(3) %>"
                                    class="rounded-lg bg-white text-black px-2 font-poppins col-span-3 row-span-2 focus:ring ring-blue-300 transition-all duration-500"
                                    required
                                >
                            </div>
                            <div class="col-span-3 row-span-3 grid grid-cols-1 grid-rows-2" >
                                <span class="text-black font-poppins text-xl font-bold">Precio</span>
                                <input
                                    type="number"
                                    name="<%= Request.Element.Room.Price %>"
                                    value="<%= rooms.getInt(4) %>"
                                    class="rounded-lg bg-white text-black px-2 font-poppins col-span-3 row-span-2 focus:ring ring-blue-300 transition-all duration-500"
                                    required
                                >
                            </div>
                            <div class="col-span-3 row-span-3 grid grid-cols-1 grid-rows-2" >
                                <span class="text-black font-poppins text-xl font-bold">Descuento</span>
                                <input
                                    type="number"
                                    name="<%= Request.Element.Room.DiscountPercent %>"
                                    value="<%= rooms.getInt(5) %>"
                                    class="rounded-lg bg-white text-black px-2 font-poppins col-span-3 row-span-2 focus:ring ring-blue-300 transition-all duration-500"
                                    required
                                >
                            </div>
                            <div class="col-span-3 row-span-3 grid grid-cols-1 grid-rows-2" >
                                <span></span>
                                <span></span>
                                <button type="submit" class="place-self-end rounded-xl bg-blue-200 px-5 py-1">Guardar</button>
                            </div>
                            <input
                                type="hidden"
                                name="<%= Request.Attributes.Command %>"
                                value="update rooms set max_people = %<%= Request.Element.Room.Capacity %>%, price = %<%= Request.Element.Room.Price %>%, discount_percent = %<%= Request.Element.Room.DiscountPercent %>% where room_number = <%= rooms.getInt(1) %>"
                            >
                            <input
                                type="hidden"
                                name="<%= Request.Attributes.Type %>"
                                value="<%= Request.Type.RoomModify %>"
                            >
                        </form>
                    </div>
                </div>
                <% } %>
                <script>
                    document.querySelectorAll(".clickListener").forEach(element => {
                        element.addEventListener("click", function() {
                            this.nextElementSibling.classList.toggle("h-40");
                            this.nextElementSibling.classList.toggle("lg:h-20");
                        });
                    });
                </script>
            </div>
        </section>
        <section class="col-span-4 lg:col-span-8 xl:col-span-4 xl:row-span-3 overflow-hidden min-h-min w-full p-5 "><!-- Employees | Clients Info -->
            <div class="p-2 rounded-xl w-full mb-1 grid grid-cols-5 place-items-center text-white font-black text-lg" style="background: #701a75">
                <span>Nombre</span>
                <span>Apellido</span>
                <span class="truncate w-full">Nivel de administracion</span>
                <span>Edad</span>
                <span></span>
            </div>
            <div class="flex flex-col relative h-full w-full overflow-y-scroll select-none px-2">
                <% while (employee.next()) { %>
                <div class="w-full grid grid-cols-5 place-items-center p-2 my-1 clickListener rounded-xl ring-1 ring-blue-4">
                    <span><%= employee.getString(1) %></span>
                    <span><%= employee.getString(2) %></span>
                    <span><%= employee.getString(3) %></span>
                    <span><%= employee.getString(4) %></span>
                    <%if (userIsAdmin && employee.getInt(3) < userLevel) {%>
                    <form method="POST" action="<%= application.getContextPath() %>/request-handler.jsp">
                        <input
                            type="hidden"
                            name="<%= Request.Attributes.Command %>"
                            value="delete from employee where user_id = <%= employee.getInt(5) %>"
                        >
                        <input
                            type="hidden"
                            name="<%= Request.Attributes.Type %>"
                            value="<%= Request.Type.UserDelete %>"
                        >
                        <button type="submit" class="place-self-end rounded-xl bg-blue-200 px-5 py-1">Eliminar</button>
                    </form>
                    <% } %>
                </div>
                <% } %>
            </div>
        </section>
        <section class="col-span-4 lg:col-span-8 xl:col-span-4 xl:row-span-3 overflow-hidden min-h-min w-full p-5 ">
            <div class="p-2 rounded-xl w-full mb-1 grid grid-cols-6 place-items-center text-white font-black text-lg" style="background: #701a75">
                <span>Nombre</span>
                <span>Apellido</span>
                <span>Correo</span>
                <span>Edad</span>
                <span>Usuario</span>
                <span></span>
            </div>
            <div class="flex flex-col relative h-full w-full overflow-y-scroll select-none px-2">
                <% while (clients.next()) { %>
                <div class="w-full grid grid-cols-6 place-items-center p-2 my-1 rounded-xl clickListener ring-1 ring-blue-4">
                    <span><%= clients.getString(1) %></span>
                    <span><%= clients.getString(2) %></span>
                    <span class="truncate w-full"><%= clients.getString(3) %></span>
                    <span><%= clients.getString(4) %></span>
                    <span><%= clients.getString(5) %></span>
                    <% if (userIsAdmin) {%>
                    <form method="POST" action="<%= application.getContextPath() %>/request-handler.jsp">
                        <input
                            type="hidden"
                            name="<%= Request.Attributes.Command %>"
                            value="delete from client where user_id = <%= clients.getInt(6) %>"
                        >
                        <input
                            type="hidden"
                            name="<%= Request.Attributes.Type %>"
                            value="<%= Request.Type.UserDelete %>"
                        >
                        <button type="submit" class="place-self-end rounded-xl bg-blue-200 px-5 py-1">Eliminar</button>
                    </form>
                    <% } %>
                </div>
                <% } %>
            </div>
        </section>
    </body>
</html>
