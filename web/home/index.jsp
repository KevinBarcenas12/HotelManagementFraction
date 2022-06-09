<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="backend.*" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="<%= application.getContextPath() %>/styles.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
        <title>Homepage</title>
        <style>
            [disabled] {
                color: red;
            }
        </style>
    <body class="select-none">
        <% if (session.getAttribute(Attributes.UserId) == null) {%>
        <script>window.location.href="<%= application.getContextPath() %>/login/";</script>
        <% } %>
        <%  Database database = new Database(application.getRealPath("/") + "hotel-database");
            boolean isDatabase = database.connect();
            if (isDatabase) try {
                database.query.execute("select room_number, max_people, discount_percent, room_type, price from rooms order by price asc");
                ResultSet rs = database.query.getResultSet();
                database.query.execute("select hotel_name from hotel_info");
                ResultSet names = database.query.getResultSet();
                String name = "";
                while (names.next()) name = names.getString(1);
                boolean isAdmin = !session.getAttribute(Attributes.UserType).toString().matches(User.Type.Client);
                boolean hasRoom = false;
                if (!isAdmin) {
                    database.query.execute("select room_number from rooms order by room_number");
                    ResultSet rs_rooms = database.query.getResultSet();
                    while (rs_rooms.next()) {
                        database.query.execute("select res_start, res_end from room_" + rs_rooms.getString(1) + " where user_id = " + session.getAttribute(Attributes.UserId).toString());
                        ResultSet rs_users = database.query.getResultSet();
                        if (rs_users.next()) {
                            if (rs_users.getDate(2).getTime() > new Date().getTime()) {
                                hasRoom = true;
                                break;
                            }
                        }
                    }
                }
        %>
        <header class="h-screen w-screen fixed top-0 left-0 grid place-items-center">
            <div class="relative w-full h-full overflow-hidden flex items-center justify-center">
                <img src="<%= application.getContextPath() %>/images/RoyaleDecameronSalinitas.jpg" style="max-width: unset" class="min-w-full min-h-full absolute" />
            </div>
            <span class="absolute text-7xl text-white font-black" style="text-shadow: 2px 2px 3px black"><%= name %></span>
            <%if (session.getAttribute(Attributes.RequestResult) != null && session.getAttribute(Attributes.RequestResult).toString().matches(Request.Result.Success)) {%><span class="absolute top-0 left-0 text-xl text-white font-black">Se ha creado tu reservacion con <span class="text-blue-300">exito</span>.</span><%}%>
        </header>
        <main class="top-full h-screen relative py-5">
            <div class="w-5/6 relative m-auto h-full bg-white rounded-xl overflow-hidden flex flex-col">
                <%if (isAdmin) {%>
                <div class="absolute w-full h-full grid place-items-center bg-black" style="--tw-bg-opacity: .25">
                    <span class="font-black">Eres un empleado, no puedes hacer reservaciones!</span>
                </div>
                <%} else if (hasRoom) {%>
                <div class="absolute w-full h-full grid place-items-center bg-black" style="--tw-bg-opacity: .25">
                    <span class="font-black">Ya tienes una reservacion activa!</span>
                </div>
                <%}%>
                <div class="p-2 rounded-xl mb-1 grid grid-cols-5 place-items-center text-white font-black text-lg" style="background: #701a75">
                    <span>Numero</span>
                    <span>Tipo</span>
                    <span>Capacidad</span>
                    <span>Precio</span>
                    <span>Disponibilidad</span>
                </div>
                <div class="w-full h-full overflow-y-scroll overflow-x-hidden px-2" id="rooms">
                    <%
                            Date actual = new Date();
                            String mainClass = "p-2 w-full rounded-xl shadow-md my-1 transition duration-100 hover:shadow-xl cursor-pointer ring-1 ring-blue-4";
                            String textClass = "whitespace-nowrap select-none";
                            String subClass = "grid grid-cols-5 place-items-center";
                            while (rs.next()) {
                                database.query.execute("select res_start, res_end from room_" + rs.getString(1));
                                ResultSet room_info = database.query.getResultSet();
                                List<Date> dates_start = new ArrayList<Date>();
                                List<Date> dates_end = new ArrayList<Date>();
                                while(room_info.next()) {
                                    if (room_info.getDate(1).getTime() > room_info.getDate(2).getTime()) continue;
                                    dates_start.add(new Date(room_info.getDate(1).getTime()));
                                    dates_end.add(new Date(room_info.getDate(2).getTime()));
                                }
                    %>
                                <div class="<%= mainClass %>">
                                    <div class="<%= subClass %> room-expandable">
                                        <!-- Content -->
                                        <span class="<%= textClass %>"><%= rs.getInt(2) %></span>
                                        <span class="<%= textClass %>"><%= rs.getInt(3) %></span>
                                        <span class="<%= textClass %>"><%= rs.getString(4) %></span>
                                        <span class="<%= textClass %>"><%= rs.getInt(5) %></span>
                                        <!-- / Content -->
                                    </div>
                                    <div class="form-space w-full h-0 bg-red-100 relative overflow-hidden transition duration-300 cursor-default">
                                        <form action="<%= application.getContextPath() %>/room-reservation.jsp" method="POST">
                                            <input
                                                type="hidden"
                                                name="<%= Request.Attributes.Command %>"
                                                value="insert into room_<%= rs.getString(1) %> (user_id, res_start, res_end) values ('<%= session.getAttribute(Attributes.UserId).toString() %>', %<%= Request.Element.Room.Res_Start %>%, %<%= Request.Element.Room.Res_End %>%)"
                                            />
                                            <input
                                                type="hidden"
                                                name="<%= Request.Element.Room.Price %>"
                                                value="<%= rs.getInt(5) %>"
                                            />
                                            <input
                                                type="hidden"
                                                name="<%= Request.Attributes.Type %>"
                                                value="<%= Request.Type.RoomRquest %>"
                                            />
                                            <input
                                                class="room-<%= rs.getInt(1) %>-res-start"
                                                type="date"
                                                name="<%= Request.Element.Room.Res_Start %>"
                                                min="<%= new SimpleDateFormat("yyyy-MM-dd").format(actual) %>"
                                                value="<%= new SimpleDateFormat("yyyy-MM-dd").format(actual) %>"
                                                onchange="update_<%= rs.getInt(1) %>()"
                                            />
                                            <input
                                                class="room-<%= rs.getInt(1) %>-res-end"
                                                type="date"
                                                name="<%= Request.Element.Room.Res_End %>"
                                                min="<%= new SimpleDateFormat("yyyy-MM-dd").format(actual) %>"
                                                value="<%= new SimpleDateFormat("yyyy-MM-dd").format(actual) %>"
                                                onchange="check_date_<%= rs.getInt(1) %>()"
                                            />
                                            <span class="room-<%= rs.getInt(1) %>-res-result"></span>
                                            <button type="submit" class="room-<%= rs.getInt(1) %>-res-button" disabled>Reservar</button>
                                            <script>
                                                const update_<%= rs.getInt(1) %> = () => {
                                                    let date_parts = document.querySelector(".room-<%= rs.getInt(1) %>-res-start").value.split('-');
                                                    date_parts[0] = parseInt(date_parts[0]);
                                                    date_parts[1] = parseInt(date_parts[1]) - 1;
                                                    date_parts[2] = parseInt(date_parts[2]);
                                                    let now = new Date(date_parts[0], date_parts[1], date_parts[2]);
                                                    let day = 86400000;
                                                    let tom = new Date(now.getTime() + day);
                                                    document.querySelector(".room-<%= rs.getInt(1) %>-res-end").min = (tom.getYear() + 1900) + "-" + ((tom.getMonth() + 1) < 10 ? "0" + (tom.getMonth() + 1) : (tom.getMonth() + 1)) + "-" + (tom.getDate() < 10 ? "0" + tom.getDate() : tom.getDate());
                                                    document.querySelector(".room-<%= rs.getInt(1) %>-res-end").value = (tom.getYear() + 1900) + "-" + ((tom.getMonth() + 1) < 10 ? "0" + (tom.getMonth() + 1) : (tom.getMonth() + 1)) + "-" + (tom.getDate() < 10 ? "0" + tom.getDate() : tom.getDate());
                                                    check_date_<%= rs.getInt(1) %>();
                                                }
                                                const check_date_<%= rs.getInt(1) %> = () => {
                                                    let date_start = Date.parse(document.querySelector(".room-<%= rs.getInt(1) %>-res-start").value) + 21600000;
                                                    let date_end = Date.parse(document.querySelector(".room-<%= rs.getInt(1) %>-res-end").value) + 21600000;
                                                    let res_start = [];
                                                    let res_end = [];
                                                    <%for (int i = 0; i < dates_start.size(); i++) {%>res_start.push(<%= dates_start.get(i).getTime() %>);<%}%>
                                                    <%for (int i = 0; i < dates_end.size(); i++) {%>res_end.push(<%= dates_end.get(i).getTime() %>);<%}%>
                                                    let flag = false;
                                                    for (let i = 0; i < res_start.length; i++) {
                                                        if ((res_start[i] < date_start && date_start < res_end[i]) || (res_start[i] < date_end && date_end < res_end[i])) {
                                                            flag = true;
                                                            break;
                                                        }
                                                    }
                                                    if (!flag) {
                                                        if (date_end - date_start > 0) {
                                                            document.querySelector(".room-<%= rs.getInt(1) %>-res-result").innerHTML = "Fecha disponible";
                                                            document.querySelector(".room-<%= rs.getInt(1) %>-res-button").disabled = false;
                                                        }
                                                        else {
                                                            document.querySelector(".room-<%= rs.getInt(1) %>-res-result").innerHTML = "Fecha no valida";
                                                            document.querySelector(".room-<%= rs.getInt(1) %>-res-button").disabled = true;
                                                        }
                                                    }
                                                    else {
                                                        document.querySelector(".room-<%= rs.getInt(1) %>-res-result").innerHTML = "Fecha no disponible!";
                                                        document.querySelector(".room-<%= rs.getInt(1) %>-res-button").disabled = true;
                                                    }
                                                }
                                            </script>
                                        </form>
                                    </div>
                                </div>
                            <%}
                        }
                        catch (Exception e) {
                            %>console.log(<%= e.getCause().getMessage() %>)<%
                        }
                    %>
                    <script>
                        document.querySelectorAll(".room-expandable").forEach(element => {
                            element.addEventListener("click", function() {
                                this.nextElementSibling.classList.toggle("h-20");
                                this.nextElementSibling.classList.toggle("mt-1");
                            });
                        });
                    </script>
                </div>
            </div>
        </main>
        <template>
            <div>
                
            </div>
        </template>
        <footer>
            
        </footer>
    </body>
</html>