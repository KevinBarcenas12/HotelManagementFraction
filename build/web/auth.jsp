<%-- 
    Document   : auth
    Created on : Dec 3, 2021, 1:27:39 AM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="backend.*" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.Properties" %>
<%@page import="java.util.Date" %>
<%@page import="javax.mail.*" %>
<%@page import="javax.mail.internet.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%
    
    Database db = new Database(application.getRealPath("/") + "hotel-database");
    boolean isConnection = db.connect();
    if (!isConnection) {
        session.setAttribute(Attributes.FormResult, Form.Result.DatabaseConnectionError);
        out.print("<script>window.location.href = \""+application.getContextPath()+"/\"</script>");
    }
    else try {
        db.query.execute("select user_id, username, password, admin_level from employee");
        ResultSet employee = db.query.getResultSet();
        
        db.query.execute("select user_id, username, password from client");
        ResultSet clients = db.query.getResultSet();

        if (session.getAttribute(Attributes.FormType) == null) {
            session.setAttribute(Attributes.FormResult, Form.Result.FormError);
            out.print("<script>history.back()</script>");
            throw new Exception(Form.Result.FormError);
        }
        
        String formType = request.getParameter(Attributes.FormType);
        session.setAttribute("form", formType);

        if (formType.matches(Form.Type.LogIn)) {
            String f_username = request.getParameter(Form.LogIn.Username);
            String f_password = request.getParameter(Form.LogIn.Password);

            if (f_username == null || f_password == null) {
                session.setAttribute(Attributes.FormResult, Form.Result.NullParameters);
                out.print("<script>history.back()</script>");
                throw new Exception(Form.Result.NullParameters);
            }

            while (employee.next()) {
                String username = employee.getString(2);
                String password = employee.getString(3);
                if (!username.matches(f_username)) continue;
                if (!password.matches(f_password)) {
                    session.setAttribute(Attributes.FormResult, Form.Result.WrongPassword);
                    out.print("<script>history.back()</script>");
                    throw new Exception(Form.Result.WrongPassword);
                }
                session.setAttribute(Attributes.UserId, employee.getString(1));
                session.setAttribute(Attributes.UserType, employee.getInt(4) == 0 ? User.Type.Employee : User.Type.Admin);
                if (employee.getInt(4) > 0) {
                    out.print("<script>window.location.href = \""+application.getContextPath()+"/admin/\"</script>");
                }
                else {
                    out.print("<script>window.location.href = \""+application.getContextPath()+"/home/\"</script>");
                }
                throw new Exception(Form.Result.Success);
            }
            
            while (clients.next()) {
                String username = clients.getString(2);
                String password = clients.getString(3);
                if (!username.matches(f_username)) continue;
                if (!password.matches(f_password)) {
                    session.setAttribute(Attributes.FormResult, Form.Result.WrongPassword);
                    out.print("<script>history.back()</script>");
                    throw new Exception(Form.Result.WrongPassword);
                }
                session.setAttribute(Attributes.UserId, clients.getString(1));
                session.setAttribute(Attributes.UserType, User.Type.Client);
                out.print("<script>window.location.href = \""+application.getContextPath()+"/home/\"</script>");
                throw new Exception(Form.Result.Success);
            }
            
            session.setAttribute(Attributes.FormResult, Form.Result.UserNotFound);
            out.print("<script>history.back()</script>");
            throw new Exception(Form.Result.UserNotFound);
        }
        if (formType.matches(Form.Type.Register)) {
            String f_name = request.getParameter(Form.Register.FirstName);
            String l_name = request.getParameter(Form.Register.LastName);
            String target_mail = request.getParameter(Form.Register.Email);
            String gender = request.getParameter(Form.Register.Gender);
            String age = request.getParameter(Form.Register.Age);
            
            if (f_name == null || l_name == null || target_mail == null || age == null || gender == null) {
                session.setAttribute(Attributes.FormResult, Form.Result.NullParameters);
                out.print("<script>history.back()</script>");
                throw new Exception(Form.Result.NullParameters);
            }
            
            String username = User.generateName(f_name, l_name);
            String password = User.generatePassword("AWcbo&BA099B0Cw1h0wOICUwboAdb0192y591d298728");
            
            db.query.execute("select email from employee");
            ResultSet mails = db.query.getResultSet();
            while (mails.next()) {
                if (target_mail.matches(mails.getString(1))) {
                    session.setAttribute(Attributes.FormResult, Form.Result.InvalidEmail);
                    out.print("<script>history.back()</script>");
                    throw new Exception(Form.Result.InvalidEmail);
                }
            }
            db.query.execute("select email from client");
            mails = db.query.getResultSet();
            while (mails.next()) {
                if (target_mail.matches(mails.getString(1))) {
                    session.setAttribute(Attributes.FormResult, Form.Result.InvalidEmail);
                    out.print("<script>history.back()</script>");
                    throw new Exception(Form.Result.InvalidEmail);
                }
            }
            
            String mail = "hoteleria.guifarro@gmail.com";
            String pass = "holaxd2021";
            
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.user", mail);
            props.put("mail.smtp.clave", pass);
            
            Session sess = Session.getDefaultInstance(props);
            MimeMessage message = new MimeMessage(sess);
            
            try {
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(target_mail));
                message.setSubject("Credenciales del usuario.");
                
                BodyPart content = new MimeBodyPart();
                String _username = "<span style='font-weight: 800'>User: </span><span style='font-weight: 500'>"+username+"</span><br/>";
                String _password = "<span style='font-weight: 800'>Pass: </span><span style='font-weight: 500'>"+password+"</span><br/>";
                content.setContent(_username + _password, "text/html");
                
                Multipart body = new MimeMultipart();
                body.addBodyPart(content);
                
                message.setContent(body);
                
                Transport transport = sess.getTransport("smtp");
                transport.connect("smtp.gmail.com", mail, pass);
                transport.sendMessage(message, message.getAllRecipients());
                transport.close();
            }
            catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("exc", "email");
                session.setAttribute(Attributes.FormResult, Form.Result.UncaughError);
                out.print("<script>history.back()</script>");
                throw new Exception(Form.Result.UncaughError);
            }
            
            db.query.executeUpdate(
                "insert into client (first_name, last_name, username, password, email, has_room) " +
                "values (\""+f_name+"\", \""+l_name+"\", \""+username+"\", \""+password+"\", \""+target_mail+"\", false)"
            );
            
            db.query.executeUpdate(
                "insert into history (user_id, is_client, event_type, change_done, exact_date) " +
                "values ('"+session.getAttribute(Attributes.UserId)+"', 'false', '" +
                Request.Type.RoomModify+"', 'Deleted user', #"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"#)"
            );
            if (!db.commit()) {
                session.setAttribute(Attributes.FormResult, Form.Result.DatabaseError);
                out.print("<script>history.back()</script>");
                throw new Exception(Form.Result.DatabaseError);
            }
            
            session.setAttribute(Attributes.FormResult, Form.Result.Success);
            out.print("<script>history.back()</script>");
        }
        throw new Exception(Form.Result.UncaughError);
    }
    catch (Exception e) {
        e.printStackTrace();
        out.print("<script>history.back()</script>");
    }
    out.print("<script>history.back()</script>");
%>