<%@ page language="java" import="java.sql.*, java.lang.*, java.util.*, comun.*" errorPage="" %>
<%if (session.getAttribute("usuario") == null)
{
	out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
BD SMBD= new BD();
ResultSet rs, rs1;
String consultas="";
String fecha_inicio=request.getParameter("p_fecha_inicio");
String fecha_fin=request.getParameter("p_fecha_fin");
int cve_persona=0, cve_persona_atiende=0, cve_persona_cancela=0, cve_persona_buscar=0, contador=0;
String observaciones="";
String fecha_estatus="";
%>
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858" id="reporte_certif">
  <thead>
    <tr class="encabezado">
      <td colspan="14" align="center">LISTA DE EX&Aacute;MENES DE CERTIFICACI&Oacute;N PAGADOS DEL <%=fecha_inicio%> AL <%=fecha_fin%> </td>
    </tr>
    <tr align="center" class="SoloTexto">
      <td>Folio</td>
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
    <%
	consultas="SELECT p.cve_persona, CONVERT(VARCHAR(10),cp.fecha_registro,103) AS fecha_registro, kz.nombre, "
	+"p.nombre+' '+p.apellido_pat+' '+p.apellido_mat AS nombre, CONVERT(VARCHAR(10),p.fecha_nacimiento,103) AS fecha_nacimiento, "
	+"cn.abreviatura, cp.consecutivo_folio_pago, "
	+"cp.cve_persona_atiende, cp.cve_persona_cancela, cp.observaciones_atiende, CONVERT(VARCHAR(10),cp.fecha_atiende,103) AS fecha_atiende, "
	+"cp.observaciones_cancela, CONVERT(VARCHAR(10),cp.fecha_cancela,103) AS fecha_cancela "
	+"FROM certificacion_persona_ziut cp "
	+"INNER JOIN personas p ON cp.cve_persona=p.cve_persona "
	+"INNER JOIN catalogo_nacionalidad cn ON cp.cve_nacionalidad=cn.cve_nacionalidad "
	+"INNER JOIN katalogo_zertificazion_ziut kz ON cp.cve_certificacion=kz.cve_certificacion "
	+"WHERE (CONVERT(VARCHAR(10),cp.fecha_registro,103) BETWEEN '"+fecha_inicio+"' AND '"+fecha_fin+"') AND (cp.consecutivo_folio_pago <> 0) "
	+"ORDER BY cp.fecha_registro DESC";
	
	rs=SMBD.SQLBD(consultas);
	
	while(rs.next())
	{
		contador++;
		cve_persona=rs.getInt(1);
		%>
    <tr id="tr_<%=contador%>" class="SoloTexto2">
      <td style="padding:5px"><%=cve_persona%></td>
      <td><%=rs.getString(2)%></td>
	  <td><%=rs.getString(3)%></td>
      <td align="left"  style="padding:5px"><%=rs.getString(4)%></td>
      <td><%=rs.getString(5)%></td>
      <td><%=rs.getString(6)%></td>
      <td><%
				consultas="SELECT expediente FROM alumnos WHERE (cve_alumno="+cve_persona+")";
				rs1=SMBD.SQLBD(consultas);
				while(rs1.next())
				{
					out.print(rs1.getString(1));
				}
				SMBD.desconectarBD();
			%>
      </td>
      <td><%
				consultas="SELECT expediente FROM alumnos_ziut WHERE (cve_alumno="+cve_persona+")";
				rs1=SMBD.SQLBD(consultas);
				while(rs1.next())
				{
					out.print(rs1.getString(1));
				}
				SMBD.desconectarBD();				
			%>
      </td>
      <td><%
				consultas="SELECT numero_nomina FROM personal WHERE (cve_persona="+cve_persona+")";
				rs1=SMBD.SQLBD(consultas);
				while(rs1.next())
				{
					out.print(rs1.getString(1));
				}
				SMBD.desconectarBD();				
			%>
      </td>
      <td><%=rs.getInt(7)%></td>
<%
cve_persona_atiende=rs.getInt(8);
cve_persona_cancela=rs.getInt(9);
%>
	<td align="center" style="padding:5px	">
	<%
	if(cve_persona_atiende!=0)
	{ 
		cve_persona_buscar=cve_persona_atiende;
		observaciones=rs.getString(10);
		fecha_estatus=rs.getString(11);
		out.print("ATENDIDO"); 
	}
	else
	{
		if(cve_persona_cancela!=0)
		{
			cve_persona_buscar=cve_persona_cancela;
			observaciones=rs.getString(12);
			fecha_estatus=rs.getString(13);
			out.print("CANCELADO");
		}
		else
		{
			out.print("SIN ATENDER");
			cve_persona_buscar=0;
			observaciones="-";
			fecha_estatus="-";
		}
	}
	%>
	</td>
	<td><%=fecha_estatus%></td>
	<td>
	<%
	if(cve_persona_buscar!=0)
	{
		consultas="SELECT p.nombre+' '+p.apellido_pat+' '+p.apellido_mat AS nombre "
		+"FROM personas p "
		+"WHERE (p.cve_persona="+cve_persona_buscar+")";
		
		rs1=SMBD.SQLBD(consultas);
		while(rs1.next())
		{
			out.print(rs1.getString(1));
		}
		SMBD.desconectarBD();
	}else
	{
		out.print("-");
	}
	%>
	</td>	
	<td><%=observaciones%></td>
    </tr>
    <%
	}
	SMBD.desconectarBD();
	%>
  </tbody>
</table>
<%
}
%>