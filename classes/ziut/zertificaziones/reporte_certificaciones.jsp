<%@ page language="java" import="java.sql.*,java.lang.*,java.util.*, certificacion_ciut.*, comun.*" %>
<%
if (session.getAttribute("usuario") != null)
{
String mensaje = String.valueOf(session.getAttribute("usuario"));
int cve_persona=Integer.parseInt(String.valueOf(session.getAttribute("clave_usuario")));

BD SMBD= new BD();
ResultSet rs;
String consultas="";
String observaciones_atiende="", observaciones_cancela="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/sic.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/normalize.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/estilos.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/bootstrap.min.css">
        <title>Reporte de Atenci&oacute;n certificaciones</title>
<script type="text/javascript" language="JavaScript1.2" src="<%=request.getContextPath()%>/jsp/menu/stmenu.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/popcalendar.js"></script>
<script language='JavaScript'  src="<%=request.getContextPath()%>/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-2.2.4.min.js"></script>
<script language='JavaScript'  src="<%=request.getContextPath()%>/js/excellentexport.js" type="text/javascript"></script>
</head>
<body>
<form action="" method="post" name="form_captura">
  <div align="center"> 
    <table width="60" border="0" align="center" cellpadding="0" cellspacing="0" class="SoloTexto2">
      <tr> 
        <td align="center">
			<img src="../../../imagenes/banner.jpg" width="759" height="80">
		</td>
      </tr>
      <tr> 
        <td>
			<script type="text/javascript" language="JavaScript1.2" src="<%=request.getContextPath()%>/jsp/menu/menu.js"></script>
        </td>
      </tr>
	<tr> 
		<td class="titulo" align="center">
			REPORTE DE ATENCI&Oacute;N A REGISTROS DE CERTIFICACIONES
		</td>
	</tr>
	<tr > 
	  <td class="usuario" align="center">
	  	<%=mensaje%>
	  </td>
	</tr>
  <tr > 
	<td class="encabezado">
	CONSULTA
	</td>
  </tr>
</table>
<br>
<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#000033" class="SoloTexto2">
	<tr>
		<td width="21%" align="left" >Fecha de inicio de registro: </td>
		<td width="30%" align="left">
		<input id="TFechaInicio" name="TFechaInicio" type="text" class="captura_obligada" size="10" maxlength="10" readonly="true" value="" placeholder="dd/mm/aaaa">
      <img id="calendario" style="cursor:pointer; visibility:visible" width="16px" height="16px" src="<%=request.getContextPath()%>/imagenes/btnCalendar.gif" alt="" onClick="popUpCalendar(this, document.form_captura.TFechaInicio, 'dd/mm/yyyy')"/>
	  	</td>
	  <td align="left" width="20%" style="padding:3px">Fecha de fin de registro:</td>	
	  <td align="left">
	  <input id="TFechaFin" name="TFechaFin" type="text" class="captura_obligada" size="10" maxlength="10" readonly="true" value="" placeholder="dd/mm/aaaa">
      <img id="calendario" style="cursor:pointer; visibility:visible" width="16px" height="16px" src="<%=request.getContextPath()%>/imagenes/btnCalendar.gif" alt="" onClick="popUpCalendar(this, document.form_captura.TFechaFin, 'dd/mm/yyyy')"/>
	  </td>
	</tr>
</table>
<table class="SoloTexto2"  width="58%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#0066FF">
<tr>
		<td width="40%" style="padding:10px" align="right"><img class="iconsButtons" src="../../../imagenes/ikonoz/seguimiento.png" width="40" height="35" onClick="FBuscar();"/><br>
				Consultar	</td>
		<td width="20%" align="center">
						<a onClick="return ExcellentExport.excel(this, 'reporte_certif', 'reporte_atencion_certificaciones');"
                       download="Reporte_atencion_certificaciones.xls">
                        <img id="btnExportar" class="iconsButtons" title="Exportar" width="40" height="35"
                             src="../../../imagenes/ikonoz/excel.png" style="cursor:pointer;">                    	</a> <br>
						Exportar				  
			</td>
		<td width="40%" align="left">
		<img class="iconsButtons" src="../../../imagenes/ikonoz/inicio.png" width="40" height="35" onClick="FSalir();"/><br>
						Salir	</td>
  </tr>
  <tr class="SoloTexto2">
	  <td align="center" colspan="3">
	  <div id="gif_espera">&nbsp;</div>	  </td>
  </tr>
</table>
<br>
<div id="tabla_registros">
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858" id="reporte_certif">
	<thead>
		<tr class="encabezado">
		  <td colspan="14" align="center">LISTA DE EX&Aacute;MENES DE CERTIFICACI&Oacute;N PAGADOS
		  </td>
		</tr>
		<tr align="center" class="SoloTexto">		
			<td>Folio <input type="hidden" name="cve_registro" id="cve_registro"  value="0"/>	</td>
			<td width="5%">Fecha Registro</td>
			<td width="10%">Certificaci&oacute;n</td>		
			<td width="20%">Nombre del aspirante</td>	
			<td width="5%">Fecha de nacimiento</td>
			<td>Nacionalidad</td>
			<td>Alumno UTSJR</td>
			<td>Alumno CIUT</td>
			<td>Empleado UTSJR</td>
			<td width="10%">Pago</td>
			  <td width="5%">Atenci&oacute;n</td>
			  <td width="5%">Fecha atenci&oacute;n</td>
			  <td width="8%">Atiende</td>
		  <td width="9%">Observaciones</td>
		</tr>
	</thead>	
	<tbody>
	<tr>
		<td colspan="14">No hay datos en la tabla</td>
	</tr>
	</tbody>	
</table>
</div>
</div>
</form>
<script language="JavaScript" type="text/JavaScript">
function function_gif_inicia()
{
	$('#gif_espera').html('<img src="<%=request.getContextPath()%>/imagenes/ajax-loader.gif" width="40" height="50">');
}
function FBuscar()
{
	if(FValidar())
	{
		function_gif_inicia();
		par={p_fecha_inicio: $('#TFechaInicio').val(),
			p_fecha_fin: $('#TFechaFin').val()  };
			$.post("reporte_certificaciones/tabla_datoz.jsp", par,
				function(htmlexterno)
				{
					$('#tabla_registros').html(htmlexterno);
					$('#gif_espera').html('&nbsp;');
					FVerificarVacio();
				}
			);
	}
}
function FVerificarVacio()
{
	if ( $("#tr_1").length > 0 ) {
	
	}else{
		$('#tabla_registros').append('<tr><td colspan="14">No hay datos en la tabla</td></tr>');
	}
}

function FValidar()
{
	if(document.form_captura.TFechaInicio.value=="" || document.form_captura.TFechaInicio.value==null)
	{
		alert("Ingrese la fecha de inicio de registro"); document.form_captura.TFechaInicio.focus(); return false;
	}else{
		if(document.form_captura.TFechaFin.value=="" || document.form_captura.TFechaFin.value==null)
		{
			alert("Ingrese la fecha de cierre de registro"); document.form_captura.TFechaFin.focus(); return false;
		}else{
			return true;
		}
	}
}
function FSalir()
{
	location.href = "inicio.jsp?menu=6&op=7";
}
</script>
</body>
</html>
<%
}
else
{
	response.sendRedirect("../../../index.html");
}
%>