<%@ page language="java" import="java.sql.*,java.lang.*,java.util.*,evaluacion.*,comun.*" errorPage=""%>
<%@ page import="java.text.DecimalFormat" %>
<%
try
{
	int intCvePeriodo = Integer.parseInt(request.getParameter("intCvePeriodo"));	
	int intCveCarrera = Integer.parseInt(request.getParameter("intCveCarrera"));	
	int intCveGrupo = Integer.parseInt(request.getParameter("intCveGrupo"));	
	int intTipoActa = Integer.parseInt(request.getParameter("intTipoActa"));	
	int intCveDirector = Integer.parseInt(request.getParameter("intCveDirector"));		
	int bandera_imprezion = Integer.parseInt(request.getParameter("bandera_imprezion"));						
	
	entrega_aktaz ent = new entrega_aktaz();   //-->> NAL 01/04/2019	
	SHA1 sha = new SHA1();	
	BD SMBD = new BD();
	ResultSet rs, rsx;
	String consultas="";	
	String strDirector = "";
	String strFirmaElectronicaDirector = "";
	
	strFirmaElectronicaDirector = "" + intCveDirector + "" + intCveGrupo + "" + intTipoActa;
	strFirmaElectronicaDirector = sha.getHash(strFirmaElectronicaDirector);
	ent.intCvePeriodo = intCvePeriodo;
	ent.intCveCarrera = intCveCarrera;
	ent.intCveGrupo = intCveGrupo;
	ent.intTipoActa = intTipoActa;
	ent.verificarTieneFirma(intTipoActa);
		
	consultas = "SELECT perso.titulo_profezional + ' ' + per.nombre + ' ' + per.apellido_pat + ' ' + per.apellido_mat AS Director "
				+ "FROM carreras_universidad AS carr "
				+ "INNER JOIN personas AS per ON per.cve_universidad = carr.cve_universidad "
				+ "INNER JOIN personal AS perso ON perso.cve_persona = per.cve_persona "
				+ "AND per.cve_persona = carr.cve_director "
				+ "WHERE carr.cve_carrera = " + intCveCarrera;					
	rs = SMBD.SQLBD(consultas);
	while (rs.next())
	{
		strDirector = rs.getString(1);
	}
	SMBD.desconectarBD();
	    
  if (bandera_imprezion > 0)
  {
	out.println("EXISTEN PROFESORES Y MATERIAS SIN CALIFICAR");
  }
  else
  {
	if(ent.intTieneFirmaActa>0)
	{
		out.println(strFirmaElectronicaDirector);
	}
	else
	{
		out.println("FALTA FIRMA ELECTRONICA DEL DIRECTOR");
	}
  }//-->>Fin if bandera_imprezion
  %>
  <br>
  ________________________________
  <br>
	<a href="javascript:FPantallaMenu();">DIRECTOR DE DIVISI&Oacute;N </a>
  <br>
	<%=strDirector%>
<%
}
catch (Exception error)
{
	out.println("Verifica tu error ---> "+ error );
}
%>
