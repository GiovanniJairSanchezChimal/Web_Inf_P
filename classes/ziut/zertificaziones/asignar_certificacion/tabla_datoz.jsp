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
int cve_participante=Integer.parseInt(request.getParameter("p_cve_participante"));
int consecutivo_folio_pago=0, cve_certificacion=0, cve_pago=0, cve_registro=0;
String observaciones_atiende="", observaciones_cancela="";
int activo=0, cve_persona_atiende=0;
%>
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
<%
}
%>