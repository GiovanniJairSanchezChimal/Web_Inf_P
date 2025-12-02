<%@ page language="java" import="java.sql.*,comun.*,java.lang.*,java.io.*,java.util.*, certificacion_ciut.*"  %>
<%
if (session.getAttribute("usuario") == null)
{
out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
int cve_persona = Integer.parseInt(request.getParameter("cve_persona"));


String mensaje = String.valueOf(session.getAttribute("usuario"));
String konzultaz="", empresa="", carrera="", grupo="", status="", causas="", trabajas="";

BD SMBD= new BD();
ResultSet rs;
CIUT_certificacion ce=new CIUT_certificacion();
ce.cve_persona=cve_persona;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../../estilos/sic.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
</script>
</head>
<body>
<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="titulo" align="center"> DATOS DEL ASPIRANTE A EXAMEN DE CERTIFICACI&Oacute;N </td>
  </tr>
  <tr> 
    <td class="usuario" align="center"> <%=mensaje%> </td>
  </tr>
  <tr> 
    <td class="encabezado" align="center"> DATOS GENERALES </td>
  </tr>
  <tr> 
    <td height="172"><div align="center">
      <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="SoloTexto2" bordercolor="#585858">
        <%
					  							   
				konzultaz = "SELECT TOP(1) p.nombre, p.apellido_pat, p.apellido_mat, "
				            +"CONVERT(VARCHAR(10),p.fecha_nacimiento,103) AS fecha_nacimiento, p.curp, p.sexo, cn.descripcion "
							+"FROM personas p "
							+"INNER JOIN certificacion_persona_ziut cp ON p.cve_persona=cp.cve_persona "
							+"INNER JOIN catalogo_nacionalidad cn ON cn.cve_nacionalidad=cp.cve_nacionalidad "
                            +"WHERE (p.cve_persona = "+cve_persona+") "
							+"ORDER BY cp.fecha_registro DESC";
					
			rs = SMBD.SQLBD(konzultaz);
			while (rs.next())
	{
	%>
        <tr>
          <td class="SoloTexto">Nombre </td>
          <td width="29%"><%=rs.getString(1)%> </td>
          <td width="29%"><%=rs.getString(2)%> </td>
          <td width="29%"><%=rs.getString(3)%> </td>
        </tr>
        <tr>
          <td class="SoloTexto"> Fecha Nacimiento </td>
          <td><font size="1" face="Arial"><%=rs.getString(4).substring(0,10)%></font></td>
          <td class="SoloTexto" align="right">Curp </td>
          <%ce.curp= rs.getString(5);%>
          <td><%=ce.curp%></td>
        </tr>
        <tr>
          <td class="SoloTexto">Sexo</td>
          <%konzultaz = rs.getString(6);%>
          <td><font size="1" face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
          <td class="SoloTexto" align="right">Nacionalidad</td>
          <%konzultaz = rs.getString(7);%>
          <td><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></td>
        </tr>
        <%
	}
	SMBD.desconectarBD();
	ce.calcular_edad();
	%>
      </table>
    </div></td>
  </tr>
 <% 
  if(ce.edad>18)
  {
  %>
  <tr> 
    <td height="19" class="encabezado" align="center"> DATOS ACADEMICOS EN LA UTSJR </td>
  </tr>
  <tr> 
    <td height="19" ><div align="center"> 
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <%		   
					  
			konzultaz = "SELECT  carreras_universidad.descripcion AS Expr1, alumnos.grado_actual, "
						+"grupos.nombre, status_alumno.descripcion, causas_mov_en_status.causa  "
						+"FROM         status_alumno INNER JOIN "
						+"causas_mov_en_status INNER JOIN "
						+"alumnos INNER JOIN "
						+"carreras_universidad ON alumnos.cve_carrera = carreras_universidad.cve_carrera ON "
						+"causas_mov_en_status.cve_causa_mov_status = alumnos.cve_causa_mov_status ON "
						+"status_alumno.cve_status = causas_mov_en_status.cve_status LEFT OUTER JOIN "
						+"grupos ON alumnos.cve_grupo = grupos.cve_grupo "
						+"WHERE (alumnos.cve_alumno = "+cve_persona+") ";
     				
					rs = SMBD.SQLBD(konzultaz);
			while (rs.next())
			{
       %>
          <tr class="SoloTexto2"> 
            <td width="19%" class="SoloTexto">Carrera : </td>
            <%konzultaz = rs.getString(1);%>
            <td width="81%"><%=(carrera!= null?konzultaz.toUpperCase():"")%></td>
          </tr>
          <tr class="SoloTexto2"> 
            <td width="19%" class="SoloTexto"> Grado : </td>
            <%konzultaz =rs.getString(2);%>
            <td width="81%"> <%=(konzultaz==null?"":konzultaz)%> </td>
          </tr>
          <tr class="SoloTexto2"> 
            <td class="SoloTexto"> Grupo : </td>
            <%konzultaz = rs.getString(3);%>
            <td> <%=(konzultaz!= null?konzultaz.toUpperCase():"")%> </td>
          </tr>
          <tr class="SoloTexto2"> 
            <td class="SoloTexto"> Status : </td>
            <%konzultaz = rs.getString(4);%>
            <td> <%=(konzultaz!= null?konzultaz.toUpperCase():"")%> </td>
          </tr>
          <tr class="SoloTexto2"> 
            <td class="SoloTexto"> Causa : </td>
            <%konzultaz = rs.getString(5);%>
            <td> <%=(konzultaz!= null?konzultaz.toUpperCase():"")%> </td>
          </tr>
          <%
		}
		SMBD.desconectarBD();
	%>
        </table>
      </div></td>
  </tr>
  <tr> 
    <td height="19" class="encabezado"><div align="center"><font face="Arial">DETALLES DEL REGISTRO</font></div></td>
  </tr>
  <tr> 
    <td height="47"><div align="center"> 
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <%
	konzultaz = "SELECT TOP(1) cp.ocupacion, cp.nombre_empresa_trabaja, ti.descripcion, cp.num_identificacion "
	+"FROM certificacion_persona_ziut cp "
	+"INNER JOIN catalogo_tipo_identificacion ti ON ti.cve_identificacion=cp.cve_identificacion "
	+"WHERE (cp.cve_persona="+cve_persona+") "
	+"ORDER BY cp.fecha_registro DESC";
	
	rs = SMBD.SQLBD(konzultaz);
	while (rs.next())
	{ 
	%>
          <tr> 
            <td width="20%" class="SoloTexto" style="padding:5px"><div align="right"><font size="1" face="Arial">Ocupaci&oacute;n:</font></div></td>
            <td width="31%" class="SoloTexto2" style="padding:5px"><font face="Arial"><%=rs.getString(1)%></font></td>
            <td width="22%" class="SoloTexto" style="padding:5px"><div align="right"><font size="1" face="Arial">Nombre de empresa donde trabaja:</font></div></td>
            <td width="27%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=(rs.getString(2)!=null ? rs.getString(2) : "")%></font></td>
          </tr>
          <tr> 
            <td class="SoloTexto"><div align="right"><font size="1" face="Arial">Identificaci&oacute;n: </font></div></td>
            <%
				if(rs.getString(3)!=null)
				{
					konzultaz = rs.getString(3);
				}else{
					konzultaz="";
				}
			%>
            <td class="SoloTexto2"><font face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
            <td class="SoloTexto" style="padding:5px"><div align="right"><font size="1" face="Arial">N&uacute;mero de identificaci&oacute;n:</font></div></td>
            <%
				if(rs.getString(4)!=null)
				{
					konzultaz = rs.getString(4);
				}else{
					konzultaz="";
				}
			%>
            <td class="SoloTexto2"><font size="1" face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
          </tr>
          <%
	}
	SMBD.desconectarBD();
	%>
        </table>
      </div></td>
  </tr>
  <tr> 
    <td height="19" class="encabezado" align="center"><font face="Arial">DATOS DE LOCALIZACI&Oacute;N</font></td>
  </tr>
  <tr> 
    <td height="29" align="center"> 
	<%
			ce.datos_comunicacion_persona();
	%>
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
		<tr> 
            <td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Celular:</font></td>
            <td width="25%" class="SoloTexto2"><font size="1" face="Arial"><%=ce.telcel%></font></td>
			<td width="15%" class="SoloTexto"><font size="1" face="Arial">Tel&eacute;fono fijo:</font></td>
            <td width="25%" class="SoloTexto2"><font size="1" face="Arial"><%=ce.telfijo%></font></td>
         </tr>
		 <tr> 
            <td class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Tel&eacute;fono del trabajo:</font></td>
            <td class="SoloTexto2"><font size="1" face="Arial"><%=ce.teltrabajo%></font></td>
			<td  class="SoloTexto"><font size="1" face="Arial">Correo electr&oacute;nico:</font></td>
            <td  class="SoloTexto2"><font size="1" face="Arial"><%=ce.correo%></font></td>
         </tr>
        </table>      </td>
  </tr>    
 <%
 }
 else
 {
 ce.datos_familiares();
 ce.datos_tutor();
 %>
 <tr> 
    <td class="encabezado"><div align="center"><font face="Arial">DETALLES DEL REGISTRO</font></div></td>
  </tr>
  <tr> 
    <td ><div align="center"> 
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <%
	konzultaz = "SELECT TOP(1) cp.ocupacion "
	+"FROM certificacion_persona_ziut cp "
	+"WHERE (cp.cve_persona="+cve_persona+") "
	+"ORDER BY cp.fecha_registro DESC";
	
	rs = SMBD.SQLBD(konzultaz);
	while (rs.next())
	{ 
	%>
          <tr> 
            <td width="20%" style="padding:5px" class="SoloTexto"><div align="right"><font size="1" face="Arial">Ocupaci&oacute;n:</font></div></td>
            <td width="80%" class="SoloTexto2"><font face="Arial"><%=rs.getString(1)%></font></td>
          </tr>
    <%
	}
	SMBD.desconectarBD();
	%>
        </table>
      </div></td>
  </tr>
 <tr> 
    <td height="19" class="encabezado" align="center"><font face="Arial">DATOS DEL TUTOR</font></td>
  </tr>
  <tr> 
    <td height="29" align="center"> 
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <tr> 
            <td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Nombre: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.nombreT + " " + ce.apellido_pat + " " + ce.apellido_mat%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Ocupaci&oacute;n: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.ocupacionT%></font></td>
          </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Celular: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.tel_celT%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Tel&eacute;fono fijo: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.tel_fijoT%></font></td>
		  </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Correo electr&oacute;nico: </font></td>
            <td width="20%" colspan="3" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.correoT%></font></td>
		  </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Calle: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.calleT%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">N&uacute;mero: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.numeroT%></font></td>
		  </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Colonia: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.coloniaT%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">C.P.: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.cpT%></font></td>
		  </tr>
		  <tr>
		  <%
		  konzultaz="SELECT UPPER(m.nombre) AS municipio,UPPER(e.nombre) AS estado, p.nombre "
		  +"FROM par3nt3zkoz p, estados e, municipios m "
		  +"WHERE (p.cve_parentezko="+ce.cve_parentescoT+") AND (e.cve_estado="+ce.cve_estadoT+") AND (m.cve_municipio="+ce.cve_municipioT+")";
		rs=SMBD.SQLBD(konzultaz);
		  while(rs.next())
		  {
		  
		  %>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Municipio: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=rs.getString(1)+", "+rs.getString(2)%></font></td>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Parentesco: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=rs.getString(3)%></font></td>			
		<%
		}
		SMBD.desconectarBD();
		%>	
		  </tr>
        </table>	</td>
  </tr> 
 <tr> 
    <td height="19" class="encabezado" align="center"><font face="Arial">DATOS DE LA MADRE</font></td>
  </tr>
  <tr> 
    <td height="29" align="center"> 
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <tr> 
            <td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Nombre: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.nom_madre + " " + ce.ape_pat_madre + " " + ce.ape_mat_madre%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Ocupaci&oacute;n: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.ocupacion_madre%></font></td>
          </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Celular: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.tel_cel_madre%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Tel&eacute;fono fijo: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.tel_fijo_madre%></font></td>
		  </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Correo electr&oacute;nico: </font></td>
            <td width="20%" colspan="3" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.correo_madre%></font></td>
		  </tr>
        </table>	</td>
  </tr>    
 <tr> 
    <td height="19" class="encabezado" align="center"><font face="Arial">DATOS DEL PADRE</font></td>
  </tr>
  <tr> 
    <td height="29" align="center"> 
        <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <tr> 
            <td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Nombre: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.nom_padre + " " + ce.ape_pat_padre + " " + ce.ape_mat_padre%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Ocupaci&oacute;n: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.ocupacion_padre%></font></td>
          </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Celular: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.tel_cel_padre%></font></td>
			<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Tel&eacute;fono fijo: </font></td>
            <td width="20%" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.tel_fijo_padre%></font></td>
		  </tr>
		  <tr>
		  	<td width="20%" class="SoloTexto" style="padding:5px"><font size="1" face="Arial">Correo electr&oacute;nico: </font></td>
            <td width="20%" colspan="3" class="SoloTexto2" style="padding:5px"><font size="1" face="Arial"><%=ce.correo_padre%></font></td>
		  </tr>
        </table>	</td>
  </tr>    
 <%
 } 
%>  
  <tr> 
    <td height="19" class="encabezado" align="center"> <font face="Arial">DOMICILIO</font> </td>
  </tr>
  <tr>
    <td height="19"> <div align="center"> 
        <table width="100%" height="96" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858">
          <%
			konzultaz ="SELECT estados.nombre, municipios.nombre AS Expr1, direcciones.colonia, direcciones.calle, "
				   +"direcciones.n_ext, direcciones.n_int, direcciones.cp "
			   	  +"FROM direcciones INNER JOIN municipios ON direcciones.cve_estado = municipios.cve_estado AND "
			   	 +"direcciones.cve_municipio = municipios.cve_municipio LEFT OUTER JOIN "
              	 +"personas ON direcciones.cve_persona = personas.cve_persona LEFT OUTER JOIN "
               +"estados ON direcciones.cve_estado = estados.cve_estado "
			   +"WHERE (personas.cve_persona = "+cve_persona+") AND (direcciones.activo=1)";
			   
//	out.println(konzultaz);
	rs = SMBD.SQLBD(konzultaz);
	while (rs.next())
	{
	%>
          <tr> 
            <td width="20%" style="padding:5px" class="SoloTexto"><div align="right"><font size="1" face="Arial">Estado:</font></div></td>
            <%konzultaz = rs.getString(1);%>
            <td width="31%" class="SoloTexto22" style="padding:5px"><font size="1" face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
            <td width="22%" class="SoloTexto" style="padding:5px" ><div align="right"><font size="1" face="Arial">Municipio:</font></div></td>
            <%konzultaz = rs.getString(2);%>
            <td width="27%" class="SoloTexto22" style="padding:5px"s><font size="1" face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
          </tr>
          <tr> 
            <td class="SoloTexto" style="padding:5px" ><div align="right"><font size="1" face="Arial">Colonia:</font></div></td>
            <%konzultaz = rs.getString(3);%>
            <td class="SoloTexto22" style="padding:5px"><font size="1" face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
            <td class="SoloTexto" style="padding:5px"><div align="right" style="padding:5px" ><font size="1" face="Arial">Calle</font></div></td>
            <%konzultaz = rs.getString(4);%>
            <td class="SoloTexto22" style="padding:5px"><font size="1" face="Arial"><%=(konzultaz!= null?konzultaz.toUpperCase():"")%></font></td>
          </tr>
          <tr> 
            <td class="SoloTexto" style="padding:5px" ><div align="right"><font size="1" face="Arial">N&uacute;mero Exterior:</font></div></td>
            <td class="SoloTexto22" style="padding:5px"><font size="1" face="Arial"><%=rs.getString(5)%></font></td>
            <td class="SoloTexto" style="padding:5px"><div align="right" style="padding:5px"><font size="1" face="Arial">C.P.:</font></div></td>
            <td align="left" style="padding:5px"><font size="1" face="Arial"><%=rs.getString(7)%></font></td>
          </tr>
          <%
	}
	SMBD.desconectarBD();
	%>
        </table>
      </div></td>
  </tr>
  
  <tr>
    <td height="29" align="center"><input name="BCerrar" type="button" id="BCerrar" value="Cerrar" onClick="window.close();"></td>
</tr>
</table>
<div align="center"> 
  <p><font size="2" face="Arial"><span class="SoloTexto22"><span>Universidad Tecnol&oacute;gica 
    de San Juan del R&iacute;o<br>
    Departamento de Inform&aacute;tica<br>
    </span> <a class="liga" href="mailto:ncruzs@utsjr.edu.mx">Coordinador de Desarrollo 
    de Sistemas</a></span> </font></p>
</div>
</body>
</html>
<%
}
%>