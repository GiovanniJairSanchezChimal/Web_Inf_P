<%@ page language="java" import="java.sql.*, java.lang.*, java.util.*, ziut.control_escolar.*, comun.*" errorPage="" %>
<%if (session.getAttribute("usuario") == null)
{
out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
BD SMBD= new BD();
ResultSet rs;
String consultas="";
int cve_participante=Integer.parseInt(request.getParameter("cve_participante"));
int consecutivo_folio_pago=0, cve_certificacion=0, cve_pago=0, cve_registro=0;
String observaciones_atiende="", observaciones_cancela="";
String mensaje = String.valueOf(session.getAttribute("usuario"));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../estilos/sic.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-2.2.4.min.js"></script>
<script language="JavaScript" type="text/JavaScript">
function function_gif_inicia()
{
	$('#gif_espera').html('<img src="<%=request.getContextPath()%>/imagenes/ajax-loader.gif" width="40" height="50">');
}	
function FGuardar()
{
	//alert("guardar");
	if(confirm("¿Estás seguro de guardar?"))
	{
		if(FValidar())
		{
			function_gif_inicia(); 
	
			par = {"p_cve_participante": $('#cve_participante').val(),
						"p_cve_certificacion" : $('#cmbCertificacion').val(),
						"p_cve_nacionalidad": $('#cmbNacionalidad').val(),
						"p_ocupacion": $('#ocupacion').val(),					
						"p_empresa_trabaja": $('#empresa_trabaja').val(),
						"p_cve_identificacion": $('#cmbTipoIdent').val(),
						"p_num_identificacion": $('#num_identificacion').val()
				};
			//alert("p_cve_persona"+par.p_cve_persona+" p_cve_certificacion "+par.p_cve_certificacion+" p_cve_nacionalidad "+par.p_cve_nacionalidad+" p_ocupacion "+par.p_ocupacion+" p_empresa_trabaja "+par.p_empresa_trabaja+" p_cve_identificacion "+par.p_cve_identificacion+" p_num_identificacion "+par.p_num_identificacion);
			$.ajax({
				data:par,
				url:"asignar_certificacion/guarda_datos.jsp",
				type: "POST",
				dataType: "JSON",
				success : function(res)
				{
					vError = res.cve_persona;
					if(vError > 0)
					{			
						alert("DATOS GUARDADOS SATISFACTORIAMENTE");									
					}
					else
					{
						alert("OCURRIO UN ERROR. CONTACTE AL ADMINISTRADOR DEL SISTEMA.");					
					}		
					$('#ocupacion').val("");
					$('#empresa_trabaja').val("");
					$('#num_identificacion').val("");
					$('#gif_espera').html('&nbsp;');
					FActualizarTabla();
				},
				error: function(jqXHR, exception){
					alert("POR FAVOR INICIA SESIÓN NUEVAMENTE");
					window.close();
				}
			});
		}
	}
}
function aMays(e, elemento) 
{
	tecla=(document.all) ? e.keyCode : e.which; 
 	elemento.value = elemento.value.toUpperCase(); 	
}
function FCerrar()
{
	window.close();
}
function FValidar()
{
	if(document.form_captura.ocupacion.value=="" || document.form_captura.ocupacion.value==null)
	{
		alert("Captura la ocupación."); document.form_captura.ocupacion.focus(); return false;
	}else{
		if(document.form_captura.empresa_trabaja.value=="" || document.form_captura.empresa_trabaja.value==" ")
		{
			alert("Captura la empresa en donde trabaja el participante."); document.form_captura.empresa_trabaja.focus(); return false;
		}else{
			if(document.form_captura.num_identificacion.value=="" || document.form_captura.num_identificacion.value==" ")
			{
				alert("Captura el número de identificación del alumno."); document.form_captura.num_identificacion.focus(); return false;
			}else{
				return true;
			}
		}
	}
}
function FActualizarTabla()
{
		function_gif_inicia();
	par={p_cve_participante: $('#cve_participante').val()	};
	$.post("asignar_certificacion/tabla_datoz.jsp", par,
		function(htmlexterno)
		{
			$('#tabla_historial').html(htmlexterno);
			$('#gif_espera').html('&nbsp;');
		}
	);
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
</script>
</head>
<body>
<form action="" method="post" name="form_captura">
 <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td class="titulo"><div align="center"><font face="Arial">ASIGNAR CERTIFICACI&Oacute;N AL PARTICIPANTE</font></div></td>
    </tr>
    <tr> 
      <td class="usuario"><div align="center"><font face="Arial"><%=mensaje%></font></div></td>
    </tr>
  </table>
   <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#0066FF">
	   <tr> 
		  <td class="encabezado" colspan="4"> <div align="center"> 
		  <input type="hidden" id="cve_participante" name="cve_participante" value="<%=cve_participante%>"/>
		  <font face="Arial"> DATOS DEL PARTICIPANTE</font></div></td>
		</tr>
          <%
				consultas = "SELECT     alumnos_ziut.expediente, CASE periodos_ziut.numero_periodo WHEN 1 THEN 'OCT-ENE' WHEN 2 THEN 'FEB-MAY' WHEN 3 THEN 'JUN-SEP' END AS PERIODO, "
				+"personas.nombre, personas.apellido_pat, personas.apellido_mat,  grupos_ziut.nombre AS grupo, carreras_universidad_ziut.descripcion, "
				+"periodos_ziut.ano "
				+"FROM         alumnos_ziut INNER JOIN "
				+"carreras_universidad_ziut ON alumnos_ziut.cve_carrera = carreras_universidad_ziut.cve_carrera INNER JOIN "
				+"grupos_ziut ON grupos_ziut.cve_grupo = alumnos_ziut.cve_grupo INNER JOIN "
				+"personas ON alumnos_ziut.cve_alumno = personas.cve_persona INNER JOIN "
				+"periodos_ziut ON alumnos_ziut.cve_universidad = periodos_ziut.cve_universidad "
				+"WHERE (alumnos_ziut.cve_alumno ="+cve_participante+") AND (periodos_ziut.activo = 1)";	
							
				rs = SMBD.SQLBD(consultas);
				while (rs.next())
				{
				
				%>
          <tr >
            <td class="SoloTexto" width="15%"  align="left" style="padding:5px">Expediente: </td>
			<td class="SoloTexto2" style="padding:5px"><%=rs.getString(1)%> </td>
            <td class="SoloTexto" align="left" width="15%" style="padding:5px">Cuatrimestre : </td>
			<td class="SoloTexto2" style="padding:5px"><%=rs.getString(2)+"-"+rs.getString(8)%></td>			
		  </tr>
          <tr > 
            <td class="SoloTexto" align="left" style="padding:5px">Nombre: </td>
			<td class="SoloTexto2" style="padding:5px"><%=rs.getString(3).toUpperCase()+" "+rs.getString(4).toUpperCase()+" "+rs.getString(5).toUpperCase()%></td>		
            <td class="SoloTexto" align="left" style="padding:5px">Grupo: </td>				
            <td class="SoloTexto2" align="left" style="padding:5px"><%=rs.getString(6).toUpperCase()%></td>
          </tr>
          <tr > 
		    <td class="SoloTexto" align="left" style="padding:5px">Carrera Actual: </td>
            <td class="SoloTexto2" align="left" style="padding:5px" ><%=rs.getString(7).toUpperCase()%></td>
		  </tr>
		  <%
		  }
		  SMBD.desconectarBD();
		  %>
		  <tr> 
		  <tr>
		  	<td align="left">
			<div id="gif_espera">&nbsp;</div>
			</td>
		  </tr>
		  <td class="encabezado" colspan="4"> <div align="center"> <font face="Arial"> ASIGNAR A CERTIFICACI&Oacute;N</font></div></td>
		</tr>
		<tr class="SoloTexto2">
			<td class="SoloTexto" align="left">Certificaci&oacute;n: * </td>
			<td colspan="3" align="left" style="padding:5px">
			<select id= "cmbCertificacion" name="cmbCertificacion" class="captura_obligada">
				<%
				consultas="SELECT cve_certificacion,nombre, CONVERT(VARCHAR(10),fecha_examen,103) AS fecha_examen "
				+"FROM katalogo_zertificazion_ziut "
				+"WHERE (CONVERT(date, GETDATE()) BETWEEN fecha_ins_inicio AND fecha_ins_fin) "
				+"ORDER BY nombre ASC";
				rs=SMBD.SQLBD(consultas);
				
				while(rs.next())
				{
				%>
					<option value="<%=rs.getInt(1)%>"><%=rs.getString(2)+"    --    FECHA EXAMEN: "+rs.getString(3)%></option>
				<%
				}
				 SMBD.desconectarBD();
				%>
			</select>			</td>
		</tr>
		<tr> 
		  <td class="encabezado" colspan="4"> <div align="center"> <font face="Arial"> INFORMACI&Oacute;N ADICIONAL</font></div></td>
		</tr>
		<tr class="SoloTexto2">
			<td class="SoloTexto" align="left">Nacionalidad: * </td>
			<td colspan="3" align="left" style="padding:5px">
			<select id= "cmbNacionalidad" name="cmbNacionalidad" class="captura_obligada">
				<%
				consultas="SELECT cve_nacionalidad, descripcion "
				+"FROM catalogo_nacionalidad "
				+"ORDER BY cve_nacionalidad";
				rs=SMBD.SQLBD(consultas);
				
				while(rs.next())
				{
				%>
					<option value="<%=rs.getInt(1)%>"><%=rs.getString(2)%></option>
				<%
				}
				 SMBD.desconectarBD();
				%>
			</select>			</td>
		</tr>
		<tr class="SoloTexto2">
			<td class="SoloTexto" align="left">Ocupaci&oacute;n: *</td>
			<td align="left" colspan="3" style="padding:5px">
				<input type="text" id="ocupacion" name="ocupacion" class="captura_obligada"  size="30" onBlur="aMays(event, this);" onKeyPress="return soloLetras(event)"/>			</td>
		</tr>
		<tr class="SoloTexto2">
			<td class="SoloTexto" align="left">Empresa donde trabaja: *</td>
			<td align="left" colspan="3" style="padding:5px"><input type="text" id="empresa_trabaja" name="empresa_trabaja" class="captura_obligada"  size="30" onBlur="aMays(event, this);" onKeyPress="return soloLetras(event)"/></td>
		</tr>
		<tr class="SoloTexto2">
			<td class="SoloTexto" align="left">Tipo de identificaci&oacute;n: * </td>
			<td  align="left" colspan="3" style="padding:5px">
			<select id= "cmbTipoIdent" name="cmbTipoIdent" class="captura_obligada">
				<%
				consultas="SELECT cve_identificacion, descripcion "
				+"FROM catalogo_tipo_identificacion "
				+"ORDER BY cve_identificacion ASC";
				rs=SMBD.SQLBD(consultas);
				
				while(rs.next())
				{
				%>
					<option value="<%=rs.getInt(1)%>"><%=rs.getString(2)%></option>
				<%
				}
				 SMBD.desconectarBD();
				%>
			</select>			</td>
		</tr>
		<tr class="SoloTexto2">
			<td class="SoloTexto" align="left">N&uacute;mero de identificaci&oacute;n: *</td>
			<td align="left" colspan="3" style="padding:5px">
					<input type="text" id="num_identificacion" name="num_identificacion" class="captura_obligada"  size="30" onBlur="aMays(event, this);" onKeyPress="return soloLetras(event)"/>
			</td>
		</tr>
  </table>
  <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#0066FF">
  	<tr class="SoloTexto2">
			<td align="right">
			<img src="../../../imagenes/ikonoz/guardar.png" alt="Guardar" width="40" height="35" title="Guardar" onClick="FGuardar();" class="iconsButtons"><br>
			Guardar
			</td>
			<td>&nbsp;</td>
			<td  align="left">
			<img src="../../../imagenes/ikonoz/salir.png" alt="Salir" width="40" height="35" title="Salir" onClick="FCerrar();" class="iconsButtons"><br>
			Salir
			</td>			
	</tr>
  </table>
  <br>
<div id="tabla_historial">
  <table  width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#999999">
  	<tr> 
		  <td class="encabezado" colspan="4"> <div align="center"> <font face="Arial">HISTORIAL DE ASIGNACIONES</font></div></td>
	</tr>
	<tr class="SoloTexto2">
		<td width="30%">Examen</td>
		<td width="20%">Fecha asignaci&oacute;n</td>	
		<td width="25%">Pago</td>	
		<td width="25%">Observaciones</td>				
	</tr>
	<%
	consultas="SELECT cp.cve_registro, kc.nombre, CONVERT(VARCHAR(10),cp.fecha_registro,103) AS fecha_registro, "
	+"cp.consecutivo_folio_pago, cp.cve_certificacion, kc.cve_pago, cp.observaciones_atiende, cp.observaciones_cancela "
	+"FROM certificacion_persona_ziut cp "
	+"INNER JOIN katalogo_zertificazion_ziut kc ON cp.cve_certificacion=kc.cve_certificacion "
	+"WHERE (cp.cve_persona="+cve_participante+") "
	+"ORDER BY cp.fecha_registro DESC";
	rs=SMBD.SQLBD(consultas);
	while(rs.next())
	{
	cve_registro=rs.getInt(1);
	%>
	<tr class="SoloTexto2">
		<td align="left" style="padding:5px"><%=rs.getString(2)%></td>
		<td><%=rs.getString(3)%></td>	
		<td>
			<%
			consecutivo_folio_pago=rs.getInt(4);
			cve_certificacion=rs.getInt(5);
			cve_pago=rs.getInt(6);
			observaciones_atiende=rs.getString(7);
			observaciones_cancela=rs.getString(8);
				if(consecutivo_folio_pago>0)
				{
					out.println(consecutivo_folio_pago);
				}else
				{
					%>
					<input id="btnImprimir_<%=cve_registro+"_"+cve_participante%>" name="btnImprimir_<%=cve_registro+"_"+cve_participante%>" type="button" 
							value="Imprimir Ficha" onClick="FImprimirFicha(<%=cve_participante%>,<%=cve_pago%>,<%=cve_certificacion%>)"/>
					<%
				}
			%>
			</td>				
		<td>
		<%
			if(observaciones_atiende!=null && observaciones_atiende!="")
			{
				out.print(observaciones_atiende);
			}else{
				if(observaciones_cancela!=null & observaciones_cancela!="")
				{
					out.print(observaciones_cancela);
				}else{
					out.print("NINGUNA");
				}
			}
		%>		</td>
	</tr>
	<%
	}
	SMBD.desconectarBD();
	%>
  </table>
  </div>  
</form>
</body>
</html>
<%
}
%>