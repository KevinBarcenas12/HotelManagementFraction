<%-- 0
    Document   : /
    Created on : Nov 30, 2021, 10:50:58 PM
    Author     : kevin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="backend.*" %>
<%@page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="styles.css"/>
        <link rel="stylesheet" href="scrollbar.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">
        <title>Hotel</title>
    </head>
    <style>
        .font-poppins {
            font-family: 'Poppins', sans-serif;
        }
        #bg-img {
            min-width: 100%;
            min-height: 100%;
            max-width: unset !important;
            max-height: unset !important;
            left: -70%;
            aspect-ratio: 2.56;
            position: absolute;
        }
        input[type="text"], input[type="password"], button {
            border: none;
            outline: none;
        }
        input[type]:invalid, input[type]:invalid {
            background: #f9aaaa;
        }
        input[type="text"]:invalid:placeholder-shown, input[type="password"]:invalid:placeholder-shown {
            background: white !important;
        }
        .toggler {
            border-radius: 50%;
            appearance: none;
            -webkit-appearance: none;
            position: fixed;
            left: 10px;
            top: 10px;
            z-index: 5;
            width: 40px;
            aspect-ratio: 1/1;
            background: hsl(200, 100%, 95%);
            transform: scale(1.05);
            transition: .25s cubic-bezier(.4,.5,.6,1.2);
            display: grid !important;
        }
    </style>
    <%  Database database = new Database(application.getRealPath("/") + "hotel-database");
        boolean isConn = database.connect();
        ResultSet rs = null;
        String hotel_name = null, mision = null, vision = null, phone = null;
        if (isConn) try {
            database.query.execute("select hotel_name, mision, vision, phone from hotel_info order by modified");
            rs = database.query.getResultSet();
            while (rs.next()) {
                hotel_name = rs.getString(1);
                mision = rs.getString(2);
                vision = rs.getString(3);
                phone = rs.getString(4);
            }
        }
        catch (Exception e) {
            
        }
    %>
    <body class="font-sans">
        <%-- Main Content --%>
        <div class="w-full h-full flex flex-col items-center justify-center" style="background: #1c1917" id="body">
            <%-- Header --%>
            <div class="w-4/5 h-5/6 lg:h-4/5 xl:h-3/4 m-auto flex flex-row justify-center p-1 lg:p-2">
                <div class="back-image bg-blue-400 h-full w-0 lg:w-1/2 xl:w-2/3 2xl:w-3/4 flex items-center justify-center overflow-hidden relative transform translate-x-10 translate-y-5 relative z-10 rounded-3xl shadow-md">
                    <img src="images/RoyaleDecameronSalinitas.jpg" loading="lazy" class="max-w-none min-w-full min-h-full absolute overflow-hidden invisible lg:visible" />
                    <img src="images/112587274.jpg" loading="lazy" class="max-w-none min-w-full min-h-full absolute overflow-hidden invisible xl:visible" />
                    <img src="images/montego-01.jpg" loading="lazy" class="max-w-none min-w-full min-h-full absolute overflow-hidden invisible 2xl:visible" />
                </div>
                <div class="transparent-scrollbar overflow-y-scroll overflow-x-hidden p-5 flex flex-col h-full w-full lg:w-3/4 xl:w-2/3 2xl:w-2/5 rounded-3xl shadow-md relative z-20" style="background: #134e4a">
                    <span class="font-black text-5xl p-2 font-poppins text-purple-300"><%= hotel_name %></span>
                    <span class="font-black text-2xl p-1 font-poppins text-blue-500 mt-3 w-full text-right mr-4">¿Nuestra mision?</span>
                    <p class="p-2 font-sans font-semibold text-justify"><%= mision %></p>
                    <span class="font-black text-2xl p-1 font-poppins text-blue-500 mt-3 w-full text-left ml-4">¿Nuestra vision?</span>
                    <p class="p-2 font-sans font-semibold text-justify"><%= vision %></p>
                    <span class="font-black text-xl p-1 font-poppins w-full text-center">Contactanos al <span class="text-purple-600"><%= phone %></span> ya!</span>
                    <a 
                        class="px-6 py-5 w-2/5 text-white font-black text-center relative m-auto mt-5 whitespace-nowrap min-w-min rounded-2xl"
                        style="background: #0c4a6e;"
                        href="<%= application.getContextPath() %>/login/">Empezar ahora! --&gt;</a>
                </div>
            </div>
            <%-- / Header --%>
        </div>
        <%-- / Main Content --%>
    </body>
</html>
