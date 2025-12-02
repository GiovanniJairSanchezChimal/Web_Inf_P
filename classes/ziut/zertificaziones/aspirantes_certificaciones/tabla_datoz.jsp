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
int contador=0;
int cve_certificacion=Integer.parseInt(request.getParameter("p_cve_certificacion"));
int cve_persona=0, cve_registro=0, cve_pago=0;
String observaciones="";
int pago=0;
%>
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#585858" id="aspirantes_certif">
	<thead>
		<tr class="encabezado">
		  <td colspan="10" align="center">ASPIRANTES A CERTIFICACI&Oacute;N SIN ATENDER
				<input type="hidden" id="tipo_observacion" name="tipo_observacion" value="0"/>	
		  </td>
		</tr>
		<tr align="center" class="SoloTexto">
			<td width="6%">Folio</td>
			<td width="7%">Fecha Registro</td>		
			<td width="20%">Nombre del aspirante</td>	
			<td width="7%">Fecha de nacimiento</td>
			<td>Nacionalidad</td>
			<td>Alumno UTSJR</td>
			<td>Alumno CIUT</td>
			<td>Empleado UTSJR</td>
			<td width="10%">Pago</td>
			<td width="20%">Observaciones</td>
		</tr>
	</thead>	
	<tbody>
	<%
	consultas="SELECT cp.cve_persona, CONVERT(VARCHAR(10),cp.fecha_registro,103) AS fecha_registro, "
		+"p.nombre+' '+p.apellido_pat+' '+p.apellido_mat AS nombre, CONVERT(VARCHAR(10),p.fecha_nacimiento,103) AS fecha_nacimiento, "
		+"cn.abreviatura, cp.consecutivo_folio_pago, kc.cve_pago, cp.observaciones_atiende,cp.cve_registro "
		+"FROM certificacion_persona_ziut cp "
		+"INNER JOIN personas p ON cp.cve_persona=p.cve_persona "
		+"INNER JOIN catalogo_nacionalidad cn ON cp.cve_nacionalidad=cn.cve_nacionalidad "
		+"INNER JOIN katalogo_zertificazion_ziut kc ON cp.cve_certificacion=kc.cve_certificacion "
		+"WHERE (cp.cve_certificacion="+cve_certificacion+") AND (CONVERT(VARCHAR(10),cp.fecha_registro,103) BETWEEN kc.fecha_ins_inicio AND kc.fecha_ins_fin) "
		+"AND (cve_persona_atiende IS NULL) AND (cve_persona_cancela IS NULL) "
		+"ORDER BY cp.fecha_registro DESC";
	rs=SMBD.SQLBD(consultas);
	
	while(rs.next())
	{
		contador++;
		cve_persona=rs.getInt(1);
		%>
		<tr class="SoloTexto2" id="tr_<%=contador%>">
			<td><a href="javascript:FMuestraDatos(<%=cve_persona%>);"><%=cve_persona%></a></td>
			<td><%=rs.getString(2)%></td>		
			<td><%=rs.getString(3)%></td>	
			<td><%=rs.getString(4)%></td>
			<td><%=rs.getString(5)%></td>
			<td>
			<%
				consultas="SELECT expediente FROM alumnos WHERE (cve_alumno="+cve_persona+")";
				rs1=SMBD.SQLBD(consultas);
				while(rs1.next())
				{
					out.print(rs1.getString(1));
				}
				SMBD.desconectarBD();
			%>
			</td>
			<td>
			<%
				consultas="SELECT expediente FROM alumnos_ziut WHERE (cve_alumno="+cve_persona+")";
				rs1=SMBD.SQLBD(consultas);
				while(rs1.next())
				{
					out.print(rs1.getString(1));
				}
				SMBD.desconectarBD();				
			%>
			</td>
			<td>
			<%
				consultas="SELECT numero_nomina FROM personal WHERE (cve_persona="+cve_persona+")";
				rs1=SMBD.SQLBD(consultas);
				while(rs1.next())
				{
					out.print(rs1.getString(1));
				}
				SMBD.desconectarBD();				
			%>
			</td>
			<td>
			<%
			pago=rs.getInt(6);
			cve_pago=rs.getInt(7);
			observaciones=rs.getString(8);
			cve_registro=rs.getInt(9);
			if(pago>0)
			{
				out.print(pago);
			}else{
				%>
				<input id="btnImprimir_<%=cve_registro+"_"+cve_persona%>" name="btnImprimir_<%=cve_registro+"_"+cve_persona%>" type="button" 
							value="Imprimir Ficha" onClick="FImprimirFicha(<%=cve_persona%>,<%=cve_pago%>,<%=cve_certificacion%>)"/>
				<%
			}
			%>
			</td>
			<td align="center" style="padding:3px">
						<textarea id="txtObservacion_<%=cve_registro+"_"+cve_persona%>" name="txtObservacion_<%=cve_registro+"_"+cve_persona%>" cols="20" rows="3" maxlength="200" style="max-height:45px; max-width:160px; min-height:45px; min-width:160px;" class="captura_obligada" onKeyUp="mayus(this);" onKeyPress="return soloLetras(event)"><%=(observaciones!=null ? observaciones : "")%></textarea>
						<input id="btnGuardar" name="btnGuardar" style="margin:5 5 5 5" type="button" value="Guardar observación" onClick="FInsertarObservacion(<%=cve_registro%>,<%=cve_persona%>,3);" /><br />
			
				<%
				if(pago>0)
				{
					%>
					<input id="btnAtender_<%=cve_registro+"_"+cve_persona%>" name="btnAtender_<%=cve_registro+"_"+cve_persona%>" type="button" 
						value="Atender registro" style="margin:0 5 5 5" onClick="FInsertarObservacion(<%=cve_registro%>,<%=cve_persona%>,1);"/>
					<%
				}else{
				%>
				<input id="btnCancelar_<%=cve_registro+"_"+cve_persona%>" name="btnCancelar_<%=cve_registro+"_"+cve_persona%>" type="button" 
							value="Cancelar registro" style="margin:0 5 5 5" onClick="FInsertarObservacion(<%=cve_registro%>,<%=cve_persona%>,2);"/>
				<%
				}
				%>			
			</td>
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