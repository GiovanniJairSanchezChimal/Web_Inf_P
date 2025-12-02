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
	int intBanderaImprimeActa3 = 0;	
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
<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" class="SoloTexto2" dwcopytype="CopyTableRow" bordercolor="#1CECE1">
<tr class="encabezado"> 
<td colspan="9" align="center" height="30"> 
  ACTAS DE CALIFICACIONES DE ACCIONES ESPECIALES DE REGULARIZACI&Oacute;N </td>
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
consultas="SELECT grupos.grado, grupos.cve_grupo, grupos.cve_periodo, grupos.nombre, grupos.nombre as nom2, "
	+"personas.apellido_pat, personas.apellido_mat, personas.nombre AS Expr1 "
	+"FROM grupos INNER JOIN "
	+"personas ON grupos.cve_maestro = personas.cve_persona "
	+"WHERE (grupos.cve_carrera ="+intCveCarrera+") "
	+ "AND (cve_periodo = (" + intCvePeriodo + ")) "
	+"AND (grupos.cve_grupo IN (Select cve_grupo from calificacionez_alumno where (opcion_calif = 3) and (cve_carrera = "+ca.cve_carrera+")) )"
	+"ORDER BY grupos.grado, grupos.nombre, personas.apellido_pat, personas.apellido_mat ";
//	out.print(consultas);				
rsx = SMBD.SQLBD(consultas);
while (rsx.next())
{
	num=num+1;
	grado = rsx.getInt(1);
	grupo = rsx.getInt(2);
	intCvePeriodo = rsx.getInt(3);
	nom_grupo = rsx.getString(4);
	
	ca.cve_grupo = grupo;
	ca.intOpcionCalif = 3;
	ca.revizion_zierre_kalifikazionez_especiales();	
	
					/*
					NAL: 11/04/2018 
					DESCRIPCIÓN: Obtener la fecha de última actualización de acuerdo al No. de materias por grupo y No.
								 de materias ya cerradas.
					*/
					xyz.cve_grupo = ca.cve_grupo;
					xyz.cve_carrera = ca.cve_carrera;
					xyz.intCvePeriodo = intCvePeriodo;              
					xyz.intOpcionCalif = 3;
					xyz.ObtenerMateriasXGrupo();
					xyz.ObtenerMateriasCerradas();
					xyz.ObtenerFechaUltimaActualizacion();
//					xyz.CuantasMateriasSegunGrupo();  //-->> 16/04/2018
//					xyz.CuantosRegistroExistenCierres();  //-->> 16/04/2018					
					xyz.CuantasMateriasDebenTenerCierre();  //-->> 20/04/2018
					xyz.CuantasMateriasTienenCierre(); //-->> 20/04/2018

					intBanderaImprimeActa3 = 0;
					
//out.println("intCuantasMateriaDebenTenerCierre -- " + xyz.intCuantasMateriaDebenTenerCierre);					
//out.println("intCuantasMateriasTienenCierre -- " + xyz.intCuantasMateriasTienenCierre);					
					if((xyz.intCuantasMateriaDebenTenerCierre>=0)&&(xyz.intCuantasMateriasTienenCierre>=0))
					{
//						if(xyz.intCuantasMateriaDebenTenerCierre == xyz.intCuantasMateriasTienenCierre)					//20/04/2018
						if(xyz.intCuantasMateriasTienenCierre >= xyz.intCuantasMateriaDebenTenerCierre)					//18/05/2018
						{
	//					out.println("Entro");
							intBanderaImprimeActa3 = 1;
							strFechaUltimaActualizacion = xyz.strFechaUltimaActualizacion;														
						}
						else
						{
							strFechaUltimaActualizacion = "FALTAN MATERIAS POR CERRAR";						
						} 															
					}
					else
					{
						strFechaUltimaActualizacion = "FALTAN MATERIAS POR CERRAR";
					}

/*										
					if(xyz.intExistenRegistros == xyz.intCuantasMateriasXGrupo)
					{
						intBanderaImprimeActa3 = 1;
					} 															
					
					if(xyz.intCuantasMateriasGrupo == xyz.intCuantasMatCerradas)
					{
						strFechaUltimaActualizacion = xyz.strFechaUltimaActualizacion;
					}
					else
					{
						strFechaUltimaActualizacion = "FALTAN MATERIAS POR CERRAR";
					}
					//-->> NAL 11/04/2018				
*/	
%>		  
<tr align="center">
<td height="20" > <%=grado%> </td>
<td> 
					<%
//					if (ca.adeuda == 0)
//out.println("ca.adeuda -- " + ca.adeuda);
//out.println("Ban " + intBanderaImprimeActa3);
					if ((ca.adeuda == 0)&&(intBanderaImprimeActa3 == 1))
					{
					%>				 
					 <a href="javascript:FActaAccionesEspecialRegularizacion(<%=grupo%>,<%=intCvePeriodo%>)" class="liga"><%=nom_grupo%></a>
					<%
					}
					else
					{
//						nom_grupo = nom_grupo + " *** ";						
					%>
					<a href="javascript:FDocentes_adeudo(<%=grupo%>,3,<%=intBanderaImprimeActa3%>)" class="liga"><%=nom_grupo%></a>
					<%
					}
					%>					 

</td>
<td><%=strFechaUltimaActualizacion%>
</td>
<td width="36%"> <%=rsx.getString(6)+"  "+rsx.getString(7)+"  "+rsx.getString(8)%> </td>
 <td><%=ent.FechaFirmoDirector%></td>
 <td><%=ent.FechaEnvioaSE%></td>
 <td>
 <% if((ent.intTieneEnvioDeActaPorDir>0)&&(ent.intTieneValidacionSE==0))
	{
 %>
	<input name="btnCancelarEnvio" type="button" id="btnCancelarEnvio" value="Cancelar Envío" onClick="cancelarEnvioDeActaPorDirector(<%=intCveCarrera%>,<%=grupo%>,<%=intCvePeriodo%>,3);" >
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
<%
}
catch (Exception error)
{
	out.println("Verifica tu error ---> "+ error );
}
%>
