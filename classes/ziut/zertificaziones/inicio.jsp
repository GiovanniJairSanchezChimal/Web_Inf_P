<%@ page language="java" import="java.sql.*,java.lang.*,java.util.*,comun.*,login.*" errorPage="../error.jsp" %>
<%
if (session.getAttribute("usuario") != null)
{
String contextPath = request.getContextPath();
String mensaje = String.valueOf(session.getAttribute("usuario"));
String consultas = "";
login log = new login();
BD SMBD = new BD();
ResultSet rs,rs1;

//out.println(request.getServerName()+request.getContextPath());

String nombre="",liga="";
String x;
int op = Integer.parseInt(request.getParameter("op"));
int menu = Integer.parseInt(request.getParameter("menu"));
int usuario = Integer.parseInt(String.valueOf(session.getAttribute("clave_usuario")));

int filas=1, y=0, izquierda=0, j=0;
int celdas =1,celdas_ext=1;
int opciones,contador=1;
nombre="";liga="";
String[][] arreglo = new String[2][20];
String [] opc = new String[20];
String encabezado = "";
String [] titulos_menu = new String [11];
int num_op = 0; 
%>
<html>
<head>
<title>Menu de inicios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="<%=request.getContextPath()%>/estilos/sic.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="JavaScript1.2" src="http://<%=request.getServerName()+request.getContextPath()%>/jsp/menu/stmenu.js"></script>
<script language="JavaScript" type="text/JavaScript">
function big(lyr) {
document.all[lyr].style.height='450px'; }

function small(lyr) {
document.all[lyr].style.height='32px';
}

function start() {

<%
consultas = "SELECT     modulos.encabezado "
	+"FROM         grupo_modulos INNER JOIN "
	+"modulos ON grupo_modulos.cve_modulos = modulos.cve INNER JOIN "
	+"grupo_seguridad ON grupo_modulos.cve_grupo = grupo_seguridad.cve_grupo INNER JOIN "
	+"usuarios ON grupo_seguridad.cve_grupo = usuarios.cve_grupo "
	+"WHERE     (modulos.activo = 1) AND (usuarios.cve_persona = "+usuario+") AND (modulos.menu = "+menu+") AND (modulos.op_menu = "+op+") "
	+"GROUP BY modulos.encabezado, modulos.encabezado, modulos.op_enca "
	+"ORDER BY modulos.op_enca "; 
rs1 = SMBD.SQLBD(consultas);
opciones=0;
while (rs1.next())
{
	opciones++;
	titulos_menu[opciones] = rs1.getString(1);
%>
document.all.Layer<%=opciones%>.style.height='32px';
<%
}
SMBD.desconectarBD();
%>
}


function inhabilitar(){ 
    alert ("security is not permitted. \n\n Contact the administrator.") 
    return false 
} 
document.oncontextmenu=inhabilitar 
</script>
</head>
<body onLoad="start()">
    <table width="60%" border="0" cellpadding="0" cellspacing="0" align="center">
      <tr align="center"> 
        <td><img src="<%=request.getContextPath()%>/imagenes/banner.jpg" width="759" height="80"></td>
      </tr>
      <tr align="center"> 
        <td> <script type="text/javascript" language="JavaScript1.2" src="http://<%=request.getServerName()+request.getContextPath()%>/jsp/menu/menu.js"></script>
        </td>
      </tr>
      <tr align="center"> 
        <td class="titulo">CIUT - CERTIFICACIONES </td>
      </tr>
	  <tr align="center"> 
        <td class="usuario"><%=mensaje%></td>
      </tr>
      <tr> 
	   <td>&nbsp;</td>
      </tr>
    </table>
<blockquote>
<%
j=1;
switch(opciones)
{
	case 1:{izquierda = 560; break;}
	case 2:{izquierda = 560; break;}
	case 3:{izquierda = 398; break;}
	case 4:{izquierda = 398; break;}
	case 5:{izquierda = 236; break;}
	case 6:{izquierda = 236; break;}
	case 7:{izquierda = 74; break;}
	case 8:{izquierda = 70; break;}
}
while (j <= opciones)
{
%>
<!--	<div id="Layer<%=j%>" style=" position:absolute; width:150px; height:450px; z-index:1; left:<%=izquierda%>px; top:173px; background-color:#FFFFFF; border: 1px none #000000; overflow: hidden" onMouseOver="big('Layer<%=j%>')"; onMouseOut="small('Layer<%=j%>')"> -->
	<div id="Layer<%=j%>" style=" position:absolute; width:150px; height:450px; z-index:1; left:<%=izquierda%>px; top:173px; background-color:#FFFFFF; border: 1px none #000000;"> 

  	<div class="SoloTexto2">-<%=titulos_menu[j].toUpperCase()%>
		<%
		rs = SMBD.SQLBD(log.set_busca_opciones(menu,op,usuario,titulos_menu[j]));
		while (rs.next())				//	recorremos todas las opciones
		{
			nombre=rs.getString(5);			// se asignan los valores de la consulta
			liga=rs.getString(6);
		%>
			<br>
			<br>
			<a href="<%=liga%>" class="SoloTexto2 liga"><%=nombre%></a>
		<%
		}
		SMBD.desconectarBD();
		%>
	</div>
</div>
<%
	izquierda = izquierda + 162;
	j++;
}
%>
</blockquote>
</body>
</html>
<%
}
else
{
	response.sendRedirect("../../../index.html");
}
%>