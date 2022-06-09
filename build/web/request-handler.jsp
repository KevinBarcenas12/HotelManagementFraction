<%-- 
    Document   : request-handler
    Created on : Dec 6, 2021, 1:02:14 AM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="backend.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%
    // TODO edit, update, remove, add elements in db
    Database database = new Database(application.getRealPath("/") + "hotel-database");
    boolean isConnection = database.connect();
    
    if (!isConnection) {
        session.setAttribute(Attributes.RequestResult, Request.Result.Error.DatabaseConnectionError);
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
        // Switch replacement
        if (type.matches(Request.Type.UserDelete)) {
            database.query.executeUpdate(sql);
            database.query.executeUpdate(
                    "insert into history (user_id, is_client, event_type, change_done, exact_date) " +
                    " values ('"+session.getAttribute(Attributes.UserId)+"', 'false', '" +
                    Request.Type.UserDelete + "', 'Deleted user', #" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "#)");
            database.commit();
            session.setAttribute(Attributes.RequestResult, Request.Result.Success);
            // EndPoint
            throw new Exception();
        }
        else if (type.matches(Request.Type.InfoModify)) {
            if (request.getParameter(Request.Element.Info.Mision) == null ||
                request.getParameter(Request.Element.Info.Vision) == null ||
                request.getParameter(Request.Element.Info.Name) == null ||
                request.getParameter(Request.Element.Info.Phone) == null) {
                session.setAttribute(Attributes.RequestResult, Request.Result.Error.InvalidRequestParameters);
                throw new Exception();
            }
            Date actual = new Date();
            sql = sql.replace("%" + Request.Element.Info.Mision + "%", request.getParameter(Request.Element.Info.Mision));
            sql = sql.replace("%" + Request.Element.Info.Vision + "%", request.getParameter(Request.Element.Info.Vision));
            sql = sql.replace("%" + Request.Element.Info.Name + "%", request.getParameter(Request.Element.Info.Name));
            sql = sql.replace("%" + Request.Element.Info.Phone + "%", request.getParameter(Request.Element.Info.Phone));
            sql = sql.replace("%" + Request.Element.Info.Date + "%", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(actual));
            if (database.query.executeUpdate(sql) >= 1) {
                database.query.executeUpdate(
                        "insert into history (user_id, is_client, event_type, change_done, exact_date) " +
                        " values ('"+session.getAttribute(Attributes.UserId)+"', 'false', '"+
                        Request.Type.InfoModify+"', 'Modified hotel info', #"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"#)");
                database.commit();
                session.setAttribute(Attributes.RequestResult, Request.Result.Success);
                throw new Exception();
            }
            session.setAttribute(Attributes.RequestResult, Request.Result.Error.DatabaseError);
            throw new Exception();
        }
        else if (type.matches(Request.Type.RoomModify)) {
            String capacity = request.getParameter(Request.Element.Room.Capacity);
            String price = request.getParameter(Request.Element.Room.Price);
            String dis_per = request.getParameter(Request.Element.Room.DiscountPercent);
            if (capacity == null || price == null || dis_per == null) {
                session.setAttribute(Attributes.RequestResult, Request.Result.Error.InvalidRequestParameters);
                // EndPoint
                throw new Exception();
            }
            sql = sql.replace("%" + Request.Element.Room.Capacity + "%", capacity);
            sql = sql.replace("%" + Request.Element.Room.Price + "%", price);
            sql = sql.replace("%" + Request.Element.Room.DiscountPercent + "%", dis_per);
            if (database.query.executeUpdate(sql) >= 1) {
                database.query.executeUpdate(
                        "insert into history (user_id, is_client, event_type, change_done, exact_date) " +
                        " values ('"+session.getAttribute(Attributes.UserId)+"', 'false', '"+
                        Request.Type.RoomModify+"', 'Modified room data', #"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"#)");
                database.commit();
                session.setAttribute(Attributes.RequestResult, Request.Result.Success);
//                EndPoint
                throw new Exception();
            }
            // EndPoint
            throw new Exception();
        }
        else if (type.matches(Request.Type.UserModify)) {
            String f_name = request.getParameter(Request.Element.Employee.FirstName);
            String l_name = request.getParameter(Request.Element.Employee.LastName);
            String admin_lvl = request.getParameter(Request.Element.Employee.AdminLevel);
            if (f_name == null || l_name == null || admin_lvl == null) {
                session.setAttribute(Attributes.RequestResult, Request.Result.Error.InvalidRequestParameters);
                throw new Exception();
            }
            sql = sql.replace("%" + Request.Element.Employee.FirstName + "%", f_name);
            sql = sql.replace("%" + Request.Element.Employee.LastName + "%", l_name);
            sql = sql.replace("%" + Request.Element.Employee.AdminLevel + "%", admin_lvl);
            if (database.query.executeUpdate(sql) >= 1) {
                database.query.executeUpdate(
                        "insert into history (user_id, is_client, event_type, change_done, exact_date) " +
                        " values ('"+session.getAttribute(Attributes.UserId)+"', 'false', '"+
                        Request.Type.UserModify+"', 'Modified user data', #"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"#)");
                database.commit();
                session.setAttribute(Attributes.RequestResult, Request.Result.Success);
                throw new Exception();
            }
            session.setAttribute(Attributes.RequestResult, Request.Result.Error.DatabaseError);
            throw new Exception();
        }
        else if (type.matches(Request.Type.UserDelete)) {
            if (database.query.executeUpdate(sql) >= 1) {
                database.commit();
                session.setAttribute(Attributes.RequestResult, Request.Result.Success);
                throw new Exception();
            }
            session.setAttribute(Attributes.RequestResult, Request.Result.Error.DatabaseError);
            throw new Exception();
        }
        // No case found
        session.setAttribute(Attributes.RequestResult, Request.Result.Error.InvalidRequestType);
    }
    catch (Exception e) {}
    out.print("<script>window.location.href = \""+application.getContextPath()+"/admin/\"</script>");
%>