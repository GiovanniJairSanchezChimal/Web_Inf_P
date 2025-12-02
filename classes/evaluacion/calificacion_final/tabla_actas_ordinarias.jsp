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
	String fecha_impresion_ordinaria = "";
	String strFechaUltimaActualizacion = "";
	int num = 0;
	int grado = 0;
	int grupo = 0;
	String nom_grupo = "";		
	int intBanderaImprimeActa1 = 0;	
	ca.cve_carrera = intCveCarrera;
	
	ent.FechaFirmoDirector = "-----";
	ent.FechaEnvioaSE = "-----";
	ent.FechaValidoSE = "-----";
	ent.intTieneEnvioDeActaPorDir = 0;
	ent.intTieneValidacionSE = 0;
	
	
	consultas = "SELECT CONVERT(VARCHAR(24), fecha_impresion, 105) AS fecha_impresion "
		+"FROM config_periodos_parciales "
		+"WHERE (cve_parcial = 3) ";
	rs = SMBD.SQLBD(consultas);
	while (rs.next())
	{
		fecha_impresion_ordinaria = rs.getString(1);
	}
	SMBD.desconectarBD();
	    
%>
<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" dwcopytype="CopyTableRow" bordercolor="#1CECE1">
          <tr class="SoloTexto">
            <td colspan="9" align="center" height="40">
			Fecha para firmar electrónicamente y enviar a Servicios Escolares : <%=fecha_impresion_ordinaria%>
			</td>
          </tr>
          <tr class="encabezado"> 
            <td colspan="9" align="center" height="30"> 
              ACTAS DE CALIFICACIONES ORDINARIAS				
			</td>
          </tr>
          <tr class="SoloTexto" align="center"> 
		   <td width="3%" colspan="1">GRADO</td>
           <td width="9%" colspan="1">GRUPO / ACTA OFICIAL </td>
           <td width="11%" colspan="1">FECHA ULTIMA ACTUALIZACIÓN </td>		   
<!--           <td width="10%">CALIFICACIONES PARCIALES </td>-->
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
					+ "AND (grupos.cve_periodo = (" + intCvePeriodo + ")) "
					+ "AND grupos.vigente = 1 " 
					+"ORDER BY grupos.grado, grupos.nombre, personas.apellido_pat, personas.apellido_mat ";
//				out.println(consultas);
					rsx = SMBD.SQLBD(consultas);
					while (rsx.next())
					{
					num = num+1;
					grado = rsx.getInt(1);
					grupo = rsx.getInt(2);
					nom_grupo = rsx.getString(3);
					
					ca.cve_grupo = grupo;
					ca.intOpcionCalif = 1;
					ca.revizion_zierre_kalifikazionez();
					
					/*
					NAL: 11/04/2018 
					DESCRIPCIÓN: Obtener la fecha de última actualización de acuerdo al No. de materias por grupo y No.
								 de materias ya cerradas.
					*/
					xyz.cve_grupo = ca.cve_grupo;
					xyz.cve_carrera = ca.cve_carrera;
					xyz.intCvePeriodo = intCvePeriodo;              
					xyz.intOpcionCalif = 1;
					xyz.revisarPuedeImprimirActa();  //-->> 15/04/2019
					intBanderaImprimeActa1 = 0;		
					
					//-->> NAL 15/04/2018
					if(xyz.intPuedeImprimirActa>0)
					{
						intBanderaImprimeActa1 = xyz.intPuedeImprimirActa;
						strFechaUltimaActualizacion = xyz.strFechaUltimaActualizacion;						
					}
					else
					{
						intBanderaImprimeActa1 = xyz.intPuedeImprimirActa;					
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
         	 <tr align="center" class="SoloTexto2"> 
		     <td height="20"> <%=grado%></td>
			 <td>
			 	<%
				if (intBanderaImprimeActa1 == 1)
				{
				%>
			 	<a href="javascript:FActa_ordinaria(<%=intCveCarrera%>,<%=grupo%>,<%=intCvePeriodo%>,1)" class="liga"><%=nom_grupo%></a>
				<%
				}
				else
				{
				%>
				<a href="javascript:FDocentes_adeudo(<%=intCvePeriodo%>,<%=grupo%>,1,<%=intBanderaImprimeActa1%>)" class="liga"><%=nom_grupo%></a>
				<%
				}
				%>
			</td>
			<%
			if(intBanderaImprimeActa1>0)
			{				
			%>
			 <td><%=strFechaUltimaActualizacion%></td>
			<%
			}
			else
			{
			%>
			 <td style="color:red;"><%=strFechaUltimaActualizacion%></td>
			<%
			}
			%>			
		     <td width="26%"><font size="1" face="Arial"><%=rsx.getString(5)+"  "+rsx.getString(6)+"  "+rsx.getString(7)%></font></td>
			 <td><%=ent.FechaFirmoDirector%></td>
			 <td><%=ent.FechaEnvioaSE%></td>
			 <td>
			 <% if((ent.intTieneEnvioDeActaPorDir>0)&&(ent.intTieneValidacionSE==0))
			 	{
			 %>
			 	<input name="btnCancelarEnvioOrdinarias" type="button" id="btnCancelarEnvioOrdinarias" value="Cancelar Envío" onClick="cancelarEnvioDeActaPorDirector(<%=intCvePeriodo%>,<%=intCveCarrera%>,<%=grupo%>,1);" >
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
