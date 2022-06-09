<%-- 
    Document   : room-reservation
    Created on : Dec 17, 2021, 4:15:19 PM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="backend.*" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%
    Database database = new Database(application.getRealPath("/") + "hotel-database");
    boolean isConn = database.connect();
    if (!isConn) {
        session.setAttribute(Attributes.RequestResult, Request.Result.Error.DatabaseConnectionError);
            session.setAttribute("msg" , "error");
        out.print("<script>history.back()</script>");
    }
    else try {
        String type = request.getParameter(Request.Attributes.Type);
        if (type == null) {
            session.setAttribute(Attributes.RequestResult, Request.Result.Error.NullRequest);
            throw new Exception();
        }
        String sql = request.getParameter(Request.Attributes.Command);
        if (sql == null) {
            session.setAttribute(Attributes.RequestResult, Request.Result.Error.InvalidRequestParameters);
            throw new Exception();
        }
        if (type.matches(Request.Type.RoomRquest)) {
            String date_a = request.getParameter(Request.Element.Room.Res_Start);
            String[] date_parts_a = date_a.split("-");
            sql = sql.replace("%" + Request.Element.Room.Res_Start + "%", "#" + date_parts_a[0]+"-"+date_parts_a[1]+"-"+date_parts_a[2] + " 00:00:00#");
            String date_b = request.getParameter(Request.Element.Room.Res_End);
            String[] date_parts_b = date_b.split("-");
            sql = sql.replace("%" + Request.Element.Room.Res_End + "%", "#" + date_parts_b[0]+"-"+date_parts_b[1]+"-"+date_parts_b[2] + " 00:00:00#");
            session.setAttribute("msg" , sql);
            database.query.executeUpdate(sql);
            database.query.executeUpdate(
                    "insert into history (user_id, is_client, event_type, payment_total, payment_type, change_done, exact_date) " +
                    " values ('"+session.getAttribute(Attributes.UserId)+"', 'true', '" +
                    Request.Type.RoomRquest + "', '"+request.getParameter(Request.Element.Room.Price)+"', 'credit', 'Reserved room', #" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "#)");
            database.commit();
            session.setAttribute(Attributes.RequestResult, Request.Result.Success);
            out.print("<script>window.location.href = \""+application.getContextPath()+"/home/\"</script>");
            // EndPoint
            throw new Exception();
        }
    }
    catch (Exception e) {
    e.printStackTrace();
    }
    out.print("<script>window.location.href = \""+application.getContextPath()+"/home/?ended\"</script>");
%>