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
        <title>Atenci&oacute;n certificaciones</title>
<script type="text/javascript" language="JavaScript1.2" src="<%=request.getContextPath()%>/jsp/menu/stmenu.js"></script>
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
			ATENCI&Oacute;N A ASPIRANTES REGISTRADOS PARA CERTIFICACI&Oacute;N
		</td>
	</tr>
	<tr > 
	  <td class="usuario" align="center">
	  	<%=mensaje%>
	  </td>
	</tr>
  <tr > 
	<td class="encabezado">
	B&Uacute;SQUEDA
	</td>
  </tr>
</table>
<br>
<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#000033" class="SoloTexto2">
	<tr>
		<td width="21%" align="left" rowspan="4">Certificaci&oacute;n:</td>
		<td width="49%" align="left" rowspan="4">
		<select id= "cmbCertificacion" name="cmbCertificacion" class="captura_obligada combo300" onChange="FBuscaFechas();">
		<option value="0" selected="selected">-- Seleccionar --</option>
		<%
		consultas="SELECT cve_certificacion, nombre "
			+"FROM katalogo_zertificazion_ziut "
			+"ORDER BY nombre ASC";
			rs=SMBD.SQLBD(consultas);
		while(rs.next())
		{
			%>
			<option value="<%=rs.getInt(1)%>" alt="<%=rs.getInt(1)%>"><%=rs.getString(2)%></option>
			<%
		}	
		SMBD.desconectarBD();
		%>
		</select>
	  </td>
	  <td align="left" style="padding:3px"><output id="l_in_inscripciones" value=""/></td>	
	  <td><strong><output id="f_in_inscripciones" value=""/></strong></td>
	</tr>
	<tr>
		<td align="left" style="padding:3px"><output id="l_fin_inscripciones" value=""/></td>	
	  <td><strong><output id="f_fin_inscripciones" value=""/></strong></td>
	</tr>
	<tr>
		<td align="left" width="20%" style="padding:3px"><output id="l_fichas" value=""/></td>	
	  	<td><strong><output id="f_fichas" value=""/></strong></td>
	</tr>
	<tr>
		<td align="left" style="padding:3px"><output id="l_examen" value=""/></td>	
	  	<td><strong><output id="f_examen" value=""/></strong></td>
	</tr>
</table>
<table class="SoloTexto2"  width="58%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#0066FF">
<tr>
		<td width="40%" style="padding:10px" align="right"><img class="iconsButtons" src="../../../imagenes/ikonoz/seguimiento.png" width="40" height="35" onClick="FBuscar();"/><br>
				Consultar	</td>
		<td width="20%">&nbsp;</td>
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
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858" id="aspirantes_certif">
	<thead>
		<tr class="encabezado">
		  <td colspan="10" align="center">ASPIRANTES A CERTIFICACI&Oacute;N SIN ATENDER
		  		<input type="hidden" id="tipo_observacion" name="tipo_observacion" value="0"/>
								
		  </td>
		</tr>
		<tr align="center" class="SoloTexto">		
			<td>Folio <input type="hidden" name="cve_registro" id="cve_registro"  value="0"/>	</td>
			<td width="5%">Fecha Registro</td>		
			<td width="20%">Nombre del aspirante</td>	
			<td width="5%">Fecha de nacimiento</td>
			<td>Nacionalidad</td>
			<td>Alumno UTSJR</td>
			<td>Alumno CIUT</td>
			<td>Empleado UTSJR</td>
			<td width="10%">Pago</td>
			<td width="10%">Observaciones</td>
		</tr>
	</thead>	
	<tbody>
	<tr>
		<td colspan="10">No hay datos en la tabla</td>
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
	cve_certificacion=$('#cmbCertificacion').val();
	if(cve_certificacion!=0)
	{
		function_gif_inicia();
		par={p_cve_certificacion: cve_certificacion  };
		$.post("aspirantes_certificaciones/tabla_datoz.jsp", par,
			function(htmlexterno)
			{
				$('#tabla_registros').html(htmlexterno);
				$('#gif_espera').html('&nbsp;');
				FVerificarVacio();
			}
		);
	}
	else
	{
		alert("Selecciona un examen de certificación");
	}
}
function FBuscaFechas()
{
	cve_certificacion=$('#cmbCertificacion').val();
	if(cve_certificacion!=0)
	{
		function_gif_inicia();
		$('#l_in_inscripciones').val("Fecha inicio inscripciones:");
		$('#l_fin_inscripciones').val("Fecha cierre inscripciones:");
		$('#l_fichas').val("Fecha entrega ficha de pago:");
		$('#l_examen').val("Fecha  de examen:");
		par={"p_cve_certificacion": cve_certificacion, "p_accion":1 };	
		$.ajax({
				data:par,
				url:"configuracion_certificaciones/buzcar_datos.jsp",
				type: "POST",
				dataType: "JSON",
				success : function(res)
				{
					$('#f_in_inscripciones').val(res.fecha_ins_inicio);
					$('#f_fin_inscripciones').val(res.fecha_ins_fin);
					$('#f_fichas').val(res.fecha_entrega_ficha);
					$('#f_examen').val(res.fecha_examen);
					$('#gif_espera').html("&nbsp;");
				},
				error: function(jqXHR, exception){
					alert("POR FAVOR INICIA SESIÓN NUEVAMENTE");
					location.href = "../../../index.html";
				}
			});
	}
	else
	{
		$('#l_in_inscripciones').val("");
		$('#l_fin_inscripciones').val("");
		$('#l_fichas').val("");
		$('#l_examen').val("");
		$('#f_in_inscripciones').val("");
		$('#f_fin_inscripciones').val("");
		$('#f_fichas').val("");
		$('#f_examen').val("");
		$('#gif_espera').html("&nbsp;");
	}
}	
function FVerificarVacio()
{
	if ( $("#tr_1").length > 0 ) {
	
	}else{
		$('#tabla_registros').append('<tr><td colspan="10">No hay datos en la tabla</td></tr>');
	}
}
	
function FInsertarObservacion(cve_reg,cve_persona, opcion){
	if(FValidar(cve_reg,cve_persona))
	{
		$('#tipo_observacion').val(opcion);
		if(confirm("¿Estás seguro?"))
		{
			function_gif_inicia(); 
	
			par = {"p_cve_registro": cve_reg,
				   "p_cve_persona": cve_persona,
				   "p_tipo_observacion" : $('#tipo_observacion').val(),
				   "p_observacion": $('#txtObservacion_'+cve_reg+'_'+cve_persona).val()
				};
			//alert("p_cve_registro="+par.p_cve_registro+"&p_cve_persona="+par.p_cve_persona+"&p_tipo_observacion="+par.p_tipo_observacion+"&par.p_observacion="+par.p_observacion);
			$.ajax({
				data:par,
				url:"aspirantes_certificaciones/guarda_comentario.jsp",
				type: "POST",
				dataType: "JSON",
				success : function(res)
				{
					vError = res.cve_registro;
					if(vError > 0)
					{			
						alert("DATOS GUARDADOS SATISFACTORIAMENTE");									
					}
					else
					{
						alert("OCURRIO UN ERROR. CONTACTE AL ADMINISTRADOR DEL SISTEMA.");					
					}
					$('#gif_espera').html('&nbsp;');
					FBuscar();
				},
				error: function(jqXHR, exception){
					alert("POR FAVOR INICIA SESIÓN NUEVAMENTE");
					location.href = "../../../index.html";
				}
			});
		}
	}
}	
function FValidar(cve_reg,cve_persona)
{
	txtval=$('#txtObservacion_'+cve_reg+'_'+cve_persona).val();
	if(txtval=="" || txtval==null)
	{
		alert("Capture la observación"); document.form_captura.id.focus(); return false;
	}else{
		return true;
	}
}
function FMuestraDatos(valor)
{
	var URL ="aspirantes_certificaciones/datos_aspirante_ziut.jsp?cve_persona="+valor;
	ventana = open(URL,"Aspirante_certificacion","status=yes,scrollbars=yes, top=20, left=250, width =600,height =700");
}
function FImprimirFicha(cve_persona, cve_pago, cve_certificacion)
{
	var URL ="rep_ficha_pago.jsp?cve_persona="+cve_persona+"&cve_concepto="+cve_pago+"&cve_certificacion="+cve_certificacion;
	ventana = open(URL,"FICHA DE PAGO","status=yes,scrollbars=yes, top=20, left=250, width =600,height =500");
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
function mayus(e) {
    e.value = e.value.toUpperCase();
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