<%-- 
    Document   : history
    Created on : Dec 17, 2021, 1:47:37 AM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="backend.*" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="<%= application.getContextPath() %>/styles.css" >
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
        <title>Registro de eventos</title>
    </head>
    <body>
        <div>
            <h1 class="w-full text-4xl text-center py-4 font-black">Historial de eventos del servidor</h1>
            <%  Database database = new Database(application.getRealPath("/") + "hotel-database");
                ResultSet events = null;
                boolean isConn = database.connect();
                if (!isConn) {
                    session.setAttribute(Attributes.FormResult, Form.Result.DatabaseConnectionError);
                }
                else {
                    database.query.execute(
                              "select distinct history.event_id, (case when history.is_client = true then client.first_name else employee.first_name end), (case when history.is_client = true then client.last_name else employee.last_name end), history.event_type, history.change_done, history.payment_total, history.payment_type, history.exact_date, history.is_client "
                            + "from history, client, employee "
                            + "where history.user_id = (case when history.is_client = true then client.user_id else employee.user_id end)"
                    );
                    events = database.query.getResultSet();
                }
            %>
            
        <div class="flex flex-col">
            <div class="bg-blue-700 grid grid-cols-4 lg:grid-cols-8">
                <span class="font-black text-center text-white truncate">Event ID</span>
                <span class="font-black text-center text-white truncate">User Type</span>
                <span class="font-black text-center text-white truncate">First User Name</span>
                <span class="font-black text-center text-white truncate">Last User Name</span>
                <span class="font-black text-center text-white truncate">Event Type</span>
                <span class="font-black text-center text-white truncate">Event Description</span>
                <span class="font-black text-center text-white truncate">Event Tags</span>
                <span class="font-black text-center text-white truncate">Date & Time</span>
            </div>
            <% while (events.next()) {%>
            <div class="grid grid-cols-4 lg:grid-cols-8 my-2 shadow-lg m-2 rounded-lg ring-1 ring-blue-400">
                <span class="text-center shadow m-1"><%= events.getInt(1) %></span>
                <span class="text-center shadow m-1"><%= events.getBoolean(9) ? "Cliente" : "Empleado" %></span>
                <span class="text-center shadow m-1"><%= events.getString(2) %></span>
                <span class="text-center shadow m-1"><%= events.getString(3) %></span>
                <span class="text-center shadow m-1"><%= events.getString(4) %></span>
                <span class="text-center shadow m-1"><%= events.getString(5) %></span>
                <span class="text-center shadow m-1">
                    <span><%= events.getInt(6) == 0 ? "No definido" : events.getInt(6) + "L. with" %></span>
                    <span><%= events.getInt(6) == 0 ? "" : events.getString(7) %></span>
                </span>
                <span class="text-center shadow-sm m-1">
                    <%= new SimpleDateFormat("yyyy-MM-dd").format(events.getDate(8)) %>
                </span>
            </div>
            <% } %>
        </div>
    </body>
</html>
