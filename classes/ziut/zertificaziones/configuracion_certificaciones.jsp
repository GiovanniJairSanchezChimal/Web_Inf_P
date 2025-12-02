<%@ page language="java" import="java.sql.*,java.lang.*,java.util.*, certificacion_ciut.*, comun.*" %>
<%
if (session.getAttribute("usuario") != null)
{
String mensaje = String.valueOf(session.getAttribute("usuario"));
int cve_persona=Integer.parseInt(String.valueOf(session.getAttribute("clave_usuario")));

BD SMBD= new BD();
ResultSet rs;
String consultas="";
int cve_certificacion=0;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/sic.css" type="text/css" />
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/normalize.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/estilos.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/estilos/bootstrap.min.css">
        <title>Configuraci&oacute;n de certificaciones</title>
<script type="text/javascript" language="JavaScript1.2" src="<%=request.getContextPath()%>/jsp/menu/stmenu.js"></script>
		<script language="JavaScript" src="<%=request.getContextPath()%>/js/popcalendar.js"></script>
<script language='JavaScript'  src="<%=request.getContextPath()%>/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-2.2.4.min.js"></script>
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
			EX&Aacute;MENES DE CERTIFICACI&Oacute;N
			<input id="cve_certificacion" name="cve_certificacion" type="hidden" value="0"/>
		</td>
	</tr>
	<tr > 
	  <td class="usuario" align="center">
	  	<%=mensaje%>
	  </td>
	</tr>
	<tr > 
        <td class="encabezado" colspan="6">
       		CONFIGURACI&Oacute;N DE EX&Aacute;MENES DE CERTIFICACI&Oacute;N
		</td>
      </tr>
	<tr>
</table>
<br>
<div id="configurar_examen">
<table width="70%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#009999" class="SoloTexto2">
	<tr>	
		<td width="15%" align="left" style="padding:7 0 7 0">Nombre de certificaci&oacute;n: </td>
		<td width="50%" align="left" colspan="5">
		<input id="nombre_cert" name="nombre_cert" class="captura_obligada" style="width: 70%" type="text" onKeyPress="return soloLetras(event)" onBlur="aMays(event, this);" maxlength="150"/>
	    </td>		
	</tr>
	<tr>
		<td width="10%" align="left" style="padding:7 0 7 0">Precio:</td>
		<td width="15%" align="left">
		<input id="precio" name="precio" class="captura_obligada" style="width: 80%" type="number" disabled/>
	    </td>	
		<td width="15%" align="left">Fecha del examen:</td>
		<td width="20%" align="left">
		<input id="TFechaExamen" name="TFechaExamen" type="text" class="captura_obligada" size="10" maxlength="10" readonly="true" value="" placeholder="dd/mm/aaaa">
      <img id="calendario" style="cursor:pointer; visibility:visible" width="16px" height="16px" src="<%=request.getContextPath()%>/imagenes/btnCalendar.gif" alt="" onClick="popUpCalendar(this, document.form_captura.TFechaExamen, 'dd/mm/yyyy')"/>
	    </td>	
		<td colspan="2" style="border:1px solid red; padding:2px"><label style="color:#FF0000">Notificar a caja d&iacute;as previos a la entrega de fichas para la configuraci&oacute;n de precios.</label></td>	
	</tr>
	<tr>
		<td width="15%" align="left" style="padding:7 0 7 0">Fecha inicio de inscripci&oacute;n:</td>
		<td width="15%" align="left">
		<input id="TFechaInicio" name="TFechaInicio" type="text" class="captura_obligada" size="10" maxlength="10" readonly="true" value="" placeholder="dd/mm/aaaa">
      <img id="calendario" style="cursor:pointer; visibility:visible" width="16px" height="16px" src="<%=request.getContextPath()%>/imagenes/btnCalendar.gif" alt="" onClick="popUpCalendar(this, document.form_captura.TFechaInicio, 'dd/mm/yyyy')"/>
	    </td>	
		<td width="15%" align="left">Fecha fin de inscripci&oacute;n:</td>
		<td width="15%" align="left">
		<input id="TFechaFin" name="TFechaFin" type="text" class="captura_obligada" size="10" maxlength="10" readonly="true" value="" placeholder="dd/mm/aaaa">
						<img id="calendario" style="cursor:pointer; visibility:visible" width="16px" height="16px" src="<%=request.getContextPath()%>/imagenes/btnCalendar.gif" alt="" onClick="popUpCalendar(this, document.form_captura.TFechaFin, 'dd/mm/yyyy')"/>
	    </td>	
		<td width="15%" align="left" style="border:1px solid red; padding:2px">Fecha entrega de fichas:</td>
		<td width="15%" align="left" style="border:1px solid red; padding:2px">
		<input id="TFechaEntrega" name="TFechaEntrega" type="text" class="captura_obligada" size="10" maxlength="10" readonly="true" value="" placeholder="dd/mm/aaaa">
						<img id="calendario" style="cursor:pointer; visibility:visible" width="16px" height="16px" src="<%=request.getContextPath()%>/imagenes/btnCalendar.gif" alt="" onClick="popUpCalendar(this, document.form_captura.TFechaEntrega, 'dd/mm/yyyy')"/>
	    </td>
	</tr>
	<tr>
		<td align="left" style="padding:7 0 7 0">Concepto de pago:</td>
		<td align="left" colspan="5">
		<select id="cmbCve_pago" name="cmbCve_pago" class="captura_obligada" style="width:50%" onChange="FBuscarConcepto();">
		<option value="0">-- Seleccionar --</option>
		<%
			consultas="SELECT cve_pago, codigo+' -- '+descripcion AS nombre "
			+"FROM cat_conceptos_caja "
			+"WHERE (grupo LIKE 'CIUT') AND (descripcion LIKE '%CERTIF%') "
			+"ORDER BY codigo ASC";
			
			rs=SMBD.SQLBD(consultas);
			
			while(rs.next())
			{
				%>
				<option value="<%=rs.getInt(1)%>"><%=rs.getString(2)%></option>
				<%
			}
			SMBD.desconectarBD();
		%>
		</select>
		</td>
	</tr>
</table>
<table class="SoloTexto2"  width="58%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#0066FF">
<tr>
		<td width="40%" style="padding:10px" align="right"><img class="iconsButtons" src="../../../imagenes/ikonoz/guardar.png" width="40" height="35" onClick="FGuardarCertificacion();"/><br>
				Guardar	</td>
		<td width="20%" align="center"><img class="iconsButtons" src="../../../imagenes/ikonoz/nuevo.png" width="40" height="35" onClick="FLimpiar();"/><br>
				Nuevo	</td>
		<td width="40%" align="left">
		<img class="iconsButtons" src="../../../imagenes/ikonoz/inicio.png" width="40" height="35" onClick="FSalir();"/><br>
						Salir</td>
  </tr>
  <tr class="SoloTexto2">
	  <td align="center" colspan="3">
	  <div id="gif_espera">&nbsp;</div>	  </td>
  </tr>
</table>
</div>
<br>
<div id="tabla_examenes">
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858" id="aspirantes_certif">
	<thead>
		<tr class="encabezado">
		  <td colspan="10" align="center">LISTA DE EX&Aacute;MENES DE CERTIFICACI&Oacute;N</td>
		</tr>
		<tr align="center" class="SoloTexto">
			<td width="15%">Nombre de la certificaci&oacute;n</td>	
			<td width="5%">Precio</td>
			<td width="12%">Concepto de pago</td>
			<td width="5%">Fecha inicio inscripciones</td>
			<td width="5%">Fecha fin inscripciones</td>
			<td width="5%">Fecha entrega fichas</td>
			<td width="5%">Fecha examen</td>
			<td width="15%">Actualiza</td>	
			<td width="5%">Fecha Actualizaci&oacute;n</td>	
		</tr>
	</thead>	
	<tbody>
	<%
	consultas="SELECT cve_certificacion, kz.nombre, con.monto, con.codigo+' -- '+con.descripcion AS concepto, "
		+"CONVERT(VARCHAR(10),fecha_ins_inicio,103) AS fecha_ins_inicio, "
		+"CONVERT(VARCHAR(10),fecha_ins_fin,103) AS fecha_ins_fin, "
		+"CONVERT(VARCHAR(10),fecha_entrega_ficha,103) AS fecha_entrega_ficha, "
		+"CONVERT(VARCHAR(10),fecha_examen,103) AS fecha_examen, "
		+"p.nombre+' '+p.apellido_pat+' '+p.apellido_mat AS persona, "		
		+"CONVERT(VARCHAR(10),fecha_actualizacion,103) AS fecha_actualizacion "
		+"FROM katalogo_zertificazion_ziut kz "
		+"INNER JOIN personas p ON kz.cve_persona=p.cve_persona "
		+"INNER JOIN cat_conceptos_caja con ON kz.cve_pago=con.cve_pago "
		+"ORDER BY nombre ASC";
	rs=SMBD.SQLBD(consultas);
	while(rs.next())
	{
		cve_certificacion=rs.getInt(1);
		%>
		<tr class="soloTexto2">
			<td style="padding:5px" align="left" width="15%"><a href="javascript:FBuscar(<%=cve_certificacion%>)"><%=rs.getString(2)%></a></td>	
			<td width="5%" align="right" style="padding:5px"><%=rs.getDouble(3)%></td>
			<td width="12%" style="padding:3px"><%=rs.getString(4)%></td>
			<td width="5%"><%=rs.getString(5)%></td>
			<td width="5%"><%=rs.getString(6)%></td>
			<td width="5%"><%=rs.getString(7)%></td>
			<td width="5%"><%=rs.getString(8)%></td>	
			<td width="15%"><%=rs.getString(9)%></td>
			<td width="5%"><%=rs.getString(10)%></td>			
		</tr>
		<%
	}
	%>
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
function FBuscar(cve_certificacion)
{
	function_gif_inicia();
	par={"p_cve_certificacion": cve_certificacion, 
		  "p_accion": 1};
	$.ajax({
			data:par,
			url:"configuracion_certificaciones/buzcar_datos.jsp",
			type: "POST",
			dataType: "JSON",
			success : function(res)
			{
				$('#cve_certificacion').val(res.cve_certificacion);
				$('#nombre_cert').val(res.nombre_certificacion);
				$('#precio').val(res.precio);
				$('#TFechaExamen').val(res.fecha_examen);
				$('#TFechaInicio').val(res.fecha_ins_inicio);
				$('#TFechaFin').val(res.fecha_ins_fin);
				$('#TFechaEntrega').val(res.fecha_entrega_ficha);
				$('#cmbCve_pago').val(res.cve_pago);
                $('#gif_espera').html("&nbsp;");
			}
		});
}
function FBuscarConcepto()
{
	cve_pago=$('#cmbCve_pago').val();
	if(cve_pago!=0)
	{
		function_gif_inicia();
		par={"p_cve_pago": cve_pago,
			"p_accion": 2};
		$.ajax({
			data:par,
			url:"configuracion_certificaciones/buzcar_datos.jsp",
			type: "POST",
			dataType: "JSON",
			success : function(res)
			{
				$('#precio').val(res.precio);
                $('#gif_espera').html("&nbsp;");
			}
		});
	}
	else
	{
		$('#precio').val(0);	
	}
}
function FGuardarCertificacion(){
	if(FValidar())
	{
		if(confirm("¿Estás seguro de guardar?"))
		{
			function_gif_inicia(); 
	
			par = {"p_cve_certificacion": $('#cve_certificacion').val(),
				   "p_nombre_certificacion": $('#nombre_cert').val(),
				   "p_precio" : $('#precio').val(),
				   "p_fecha_examen":$('#TFechaExamen').val(),
				   "p_fecha_ins_inicio": $('#TFechaInicio').val(),
				   "p_fecha_ins_fin": $('#TFechaFin').val(),
				   "p_fecha_entrega_ficha": $('#TFechaEntrega').val(),
				   "p_cve_pago": $('#cmbCve_pago').val(),
				   "p_cve_persona": <%=cve_persona%>
				};
			//alert("p_cve_certificacion="+par.p_cve_certificacion+"&p_nombre_certificacion="+par.p_nombre_certificacion+"&par.p_precio="+par.p_precio+"&p_fecha_examen="+par.p_fecha_examen+"&p_fecha_ins_inicio="+par.p_fecha_ins_inicio+"&p_fecha_ins_fin="+par.p_fecha_ins_fin+"&p_fecha_entrega_ficha="+par.p_fecha_entrega_ficha+"&p_cve_pago="+par.p_cve_pago+"&p_cve_persona="+par.p_cve_persona);
			$.ajax({
				data:par,
				url:"configuracion_certificaciones/guarda_datoz.jsp",
				type: "POST",
				dataType: "JSON",
				success : function(res)
				{
					vError = res.cve_certificacion;
					if(vError > 0)
					{			
						alert("DATOS GUARDADOS SATISFACTORIAMENTE");									
					}
					else
					{
						alert("OCURRIO UN ERROR. CONTACTE AL ADMINISTRADOR DEL SISTEMA.");					
					}
					$('#gif_espera').html('&nbsp;');
					FActualizarTabla();
				},
				error: function(jqXHR, exception){
					alert("POR FAVOR INICIA SESIÓN NUEVAMENTE");
					location.href = "../../../index.html";
				}
			});
		}
	}
}	
function FActualizarTabla()
{
	function_gif_inicia();
	$.post("configuracion_certificaciones/tabla_datoz.jsp",
		function(htmlexterno)
		{
			$('#tabla_examenes').html(htmlexterno);
			$('#gif_espera').html('&nbsp;');
		}
	);
}
function FLimpiar()
{
	function_gif_inicia();
	$('#cve_certificacion').val(0);
	$('#nombre_cert').val("");
	$('#precio').val(0);
	$('#TFechaExamen').val("");
	$('#TFechaInicio').val("");
	$('#TFechaFin').val("");
	$('#TFechaEntrega').val("");
	$('#cmbCve_pago').val(0);
	$('#gif_espera').html('&nbsp;');
}
function FValidar()
{
	if(document.form_captura.nombre_cert.value=="" || document.form_captura.nombre_cert.value==null)
	  {alert("El nombre de certificación es obligatorio.");document.form_captura.nombre_cert.focus(); return false;}
	 else
	 {
		 if(document.form_captura.precio.value=="" || document.form_captura.precio.value==null || document.form_captura.precio.value<1 || document.form_captura.precio.value==0)
		  {alert("El precio no es válido.");document.form_captura.precio.focus(); return false;}
		 else
		 {
			 if(document.form_captura.TFechaExamen.value=="" || document.form_captura.TFechaExamen.value==null)
			  {alert("La fecha de examen es obligatoria.");document.form_captura.TFechaExamen.focus(); return false;}
			 else
			 {
				 if(document.form_captura.TFechaInicio.value=="" || document.form_captura.TFechaInicio.value==null)
				  {alert("La fecha de inicio de inscripciones es obligatoria.");document.form_captura.TFechaInicio.focus(); return false;}
				 else
				 {
					 if(document.form_captura.TFechaFin.value=="" || document.form_captura.TFechaFin.value==null)
					  {alert("La fecha de cierre de inscripciones es obligatoria.");document.form_captura.TFechaFin.focus(); return false;}
					 else
					 {
						 if(document.form_captura.TFechaEntrega.value=="" || document.form_captura.TFechaEntrega.value==null)
						  {alert("La fecha de entrega de fichas de pago es obligatoria.");document.form_captura.TFechaEntrega.focus(); return false;}
						 else
						 {
						 	return true;
						 }
					 }
				 }
			 }
		 }
	 }
}
function soloLetras(e) {
	key = e.keyCode || e.which;
	tecla = String.fromCharCode(key).toLowerCase();
	letras = " áéíóúabcdefghijklmnñopqrstuvwxyz.,";
	especiales = [9, 8, 39, 45, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57];
	tecla_especial = false
	for (var i in especiales) {
		if (key == especiales[i]) {
			tecla_especial = true;
			break;
		}
		if(key==39){
		  break;
		}
	}
	if (letras.indexOf(tecla) == -1 && !tecla_especial)
		return false;
}
function aMays(e, elemento) 
{
	tecla=(document.all) ? e.keyCode : e.which; 
 	elemento.value = elemento.value.toUpperCase(); 	
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