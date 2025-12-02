<%@ page language="java" 
                contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"
                import="java.sql.*,java.lang.*,java.util.*, comun.*, certificacion_ciut.*" errorPage="../../error.jsp" 
                import="org.json.simple.JSONObject"
%>
<%
if (session.getAttribute("usuario") == null)
{
out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
int cuenta_correctos=0;
try
{		
		CIUT_certificacion ce=new CIUT_certificacion();
		
		ce.cve_persona=Integer.parseInt(request.getParameter("p_cve_participante"));
		ce.cve_certificacion = Integer.parseInt(request.getParameter("p_cve_certificacion"));	
		
		//CERTIFICACION_PERSONA_ZIUT
		ce.cve_nacionalidad=Integer.parseInt(request.getParameter("p_cve_nacionalidad"));
		ce.ocupacion = request.getParameter("p_ocupacion").trim();										
		ce.nombre_empresa_trabaja = request.getParameter("p_empresa_trabaja").trim();	
		ce.cve_identificacion = Integer.parseInt(request.getParameter("p_cve_identificacion"));								
		ce.num_identificacion = request.getParameter("p_num_identificacion").trim();					 
													
		ce.asignaPersonaCertificacion();		
		cuenta_correctos+=ce.success_check;//revision de ejecucion correcta	
		 
		if(cuenta_correctos<1)
		{
			ce.cve_persona=0;
		}
		
		JSONObject json = new JSONObject();
		json.put("cve_persona", ce.cve_persona);
		out.print(json); 
 		out.flush(); 
}
catch (Exception exc)
{
	out.println("Revisa tu error--> "+exc);
}
}
%>
