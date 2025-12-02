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
int cve_certificacion=0;
%>
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
<%
}
%>