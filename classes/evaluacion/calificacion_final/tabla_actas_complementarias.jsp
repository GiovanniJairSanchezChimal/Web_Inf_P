<%@ page language="java" import="java.sql.*,java.lang.*,java.util.*,evaluacion.*,comun.*" errorPage=""%>
<%@ page import="java.text.DecimalFormat" %>
<%
try
{
	int intCveCarrera = Integer.parseInt(request.getParameter("intCveCarrera"));
	int intCvePeriodo = Integer.parseInt(request.getParameter("intCvePeriodo"));	
	
	calificacion_final ca = new calificacion_final();
	actas xyz = new actas();  
	entrega_aktaz ent = new entrega_aktaz();   //-->> NAL 01/04/2019	
	BD SMBD = new BD();
	ResultSet rs, rsx;
	String consultas="";
	String fecha_impresion_extraordinaria = "";
	String strFechaUltimaActualizacion = "";
	int num = 0;
	int grado = 0;
	int grupo = 0;
	String nom_grupo = "";		
	int intBanderaImprimeActa2 = 0;	
	ca.cve_carrera = intCveCarrera;
	
	ent.FechaFirmoDirector = "-----";
	ent.FechaEnvioaSE = "-----";
	ent.FechaValidoSE = "-----";
	ent.intTieneEnvioDeActaPorDir = 0;
	ent.intTieneValidacionSE = 0;
	
	consultas = "SELECT CONVERT(VARCHAR(24), fecha_impresion, 105) AS fecha_impresion "
		+"FROM config_periodos_parciales "
		+"WHERE (cve_parcial = 333) ";
	rs = SMBD.SQLBD(consultas);
	while (rs.next())
	{
		fecha_impresion_extraordinaria = rs.getString(1);
	}
	SMBD.desconectarBD();
	    
%>
<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" class="SoloTexto2" dwcopytype="CopyTableRow" bordercolor="#1CECE1">
<tr class="SoloTexto">
<td colspan="9" align="center" height="40">
Fecha para firmar electrónicamente y enviar a Servicios Escolares : <%=fecha_impresion_extraordinaria%>
</td>
</tr>
<tr class="encabezado" align="center"> 
<td colspan="9" height="30">ACTAS DE CALIFICACIONES COMPLEMENTARIAS </td>
</tr>
<tr class="SoloTexto" align="center"> 
	<td width="3%" colspan="1">GRADO</td>
	<td width="9%" colspan="1">GRUPO / ACTA OFICIAL </td>
	<td width="11%" colspan="1">FECHA ULTIMA ACTUALIZACIÓN </td>		   
	<td width="26%">ASESOR </td>
	<td width="11%">FIRMA ELECTRÓNICA</td>
	<td width="8%">FECHA DE ENVIO A SE.</td>
	<td width="9%">CANCELAR ENVÍO </td>
	<td width="13%">FECHA VALIDACIÓN DE SE. </td>		   		   		   		   
</tr>
<%
if (ca.cve_carrera > 0)
{
  num=0;
		consultas="SELECT grupos.grado, grupos.cve_grupo, grupos.nombre, grupos.nombre as nom2, personas.apellido_pat, personas.apellido_mat, personas.nombre AS Expr1 "
			+"FROM grupos INNER JOIN "
			+"personas ON grupos.cve_maestro = personas.cve_persona "
			+"WHERE (grupos.cve_carrera ="+intCveCarrera+") "
			+ "AND (cve_periodo = (" + intCvePeriodo + ")) "
			+"ORDER BY grupos.grado, grupos.nombre, personas.apellido_pat, personas.apellido_mat ";
				
				rsx = SMBD.SQLBD(consultas);
				while (rsx.next())
				{
				num=num+1;
				grado=rsx.getInt(1);
				grupo=rsx.getInt(2);
				nom_grupo = rsx.getString(3);
				
				ca.cve_grupo = grupo;
				ca.intOpcionCalif = 2;
				ca.revizion_zierre_kalifikazionez();
				xyz.cve_grupo = ca.cve_grupo;
				xyz.cve_carrera = ca.cve_carrera;
				xyz.intCvePeriodo = intCvePeriodo;              
				xyz.intOpcionCalif = 2;
				xyz.revisarPuedeImprimirActa();  //-->> 15/04/2019					
				intBanderaImprimeActa2 = 0;				
//out.println(intBanderaImprimeActa2);					
				//-->> NAL 15/04/2018
				if(xyz.intPuedeImprimirActa>0)
				{
					intBanderaImprimeActa2 = xyz.intPuedeImprimirActa;
					strFechaUltimaActualizacion = xyz.strFechaUltimaActualizacion;						
				}
				else
				{
					intBanderaImprimeActa2 = xyz.intPuedeImprimirActa;					
					strFechaUltimaActualizacion = "FALTAN MATERIAS POR CERRAR";					
				}							
				//-->> FIN									
				//-->> INICIO: NAL 01/04/2019
				ent.intCvePeriodo = xyz.intCvePeriodo;
				ent.intCveCarrera = ca.cve_carrera;
				ent.intCveGrupo = ca.cve_grupo;
				ent.intTipoActa = xyz.intOpcionCalif;
				
				ent.obtenerDatosDeEntregaActas(ent.intTipoActa);
				ent.verificarTieneEnvioDeActaPorDirector(ent.intTipoActa);
				ent.verificarTieneValidacionSE(ent.intTipoActa);
				//-->> FIN: NAL 01/04/2019										
								
	 %>
				 <tr align="center"> 
				 <td height="20" > <%=grado%> </td>
				 <td>
					<%
//					if (ca.adeuda == 0)
//					if ((ca.adeuda == 0)&&(intBanderaImprimeActa2 == 1))
//out.println("intBanderaImprimeActa2 -- " + intBanderaImprimeActa2);
					if (intBanderaImprimeActa2 == 1)
					{
					%>				 
					 <a href="javascript:FActa_complementaria(<%=intCveCarrera%>,<%=grupo%>,<%=intCvePeriodo%>,2)" class="liga"><%=nom_grupo%></a>
					<%
					}
					else
					{
//						nom_grupo = nom_grupo + " *** ";						
					%>
				    <a href="javascript:FDocentes_adeudo(<%=intCvePeriodo%>,<%=grupo%>,2,<%=intBanderaImprimeActa2%>)" class="liga"><%=nom_grupo%></a>					
					<%
					}
					%>					 
				 </td>
				 <td><%=strFechaUltimaActualizacion%></td>
				 <td width="36%"> <%=rsx.getString(5)+"  "+rsx.getString(6)+"  "+rsx.getString(7)%> </td>
				 <td><%=ent.FechaFirmoDirector%></td>
				 <td><%=ent.FechaEnvioaSE%></td>
				 <td>
				 <% if((ent.intTieneEnvioDeActaPorDir>0)&&(ent.intTieneValidacionSE==0))
					{
				 %>
					<input name="btnCancelarEnvio" type="button" id="btnCancelarEnvio" value="Cancelar Envío" onClick="cancelarEnvioDeActaPorDirector(<%=intCveCarrera%>,<%=grupo%>,<%=intCvePeriodo%>,2);" >
				 <%
					}
				 %>
				 </td>
				 <td><%=ent.FechaValidoSE%></td>			 			 			 			
				 </tr>
			  <%		  
							 ent.FechaFirmoDirector = "-----";
							 ent.FechaEnvioaSE = "-----";
							 ent.FechaValidoSE = "-----";
							 ent.intTieneEnvioDeActaPorDir = 0;
							 ent.intTieneValidacionSE = 0;
						 }
						 SMBD.desconectarBD();
				}
			 %>
</table>
  <br>
	<div align="center">
		<table>
			<tr class="SoloTextoVerde" align="center">
				<td>
					<strong>NOTA:&nbsp;</strong> Te recomendamos que imprimas el acta con escala 70 ( Imprimir/Mas opciones/Escala ).
				</td>
			</tr>
		</table>
	</div>

<%
}
catch (Exception error)
{
	out.println("Verifica tu error ---> "+ error );
}
%>
