<%@ page language="java" import="java.sql.*,net.sf.jasperreports.engine.*,java.lang.*,java.io.*,java.util.*,java.text.DecimalFormat, direccion.*,comun.*, gestion_recursos.contable.caja.*" errorPage="" %>
<%@ page import="net.sf.jasperreports.engine.export.JRXlsExporter" %>
<%@ page import="net.sf.jasperreports.engine.export.JRXlsExporterParameter" %>
<%
if (session.getAttribute("usuario") == null)
{
out.print("FAVOR DE INICIAR SESION NUEVAMENTE");
}
else
{
int cve_persona = Integer.parseInt(request.getParameter("cve_persona"));//cve_persona
int cve_concepto = Integer.parseInt(request.getParameter("cve_concepto")); //cve_concepto
int cve_certificacion = Integer.parseInt(request.getParameter("cve_certificacion"));
int cve_periodo=0;


DecimalFormat formato = new DecimalFormat("###,###,###.##");
general_referencia_ziut ca= new general_referencia_ziut();
BD SMBD = new BD();
Map parameters = new HashMap();
convercion_num d = new convercion_num();


String consultas = "", nombre="", fecha_actual="", fecha_aviso="", aviso="", aviso_unidad="";
ResultSet rs;
String servidor = request.getServerName();
String nom_archivo = "Ficha_de_pago_3_bancoz_ciut.jasper";
int total=0;
double monto=0;
int cve_periodo1=0;

String curp = "";
String texto="", descripcion="", periodo="";
String referencias="";
String fecha_vencimiento="";
int Nobanorte=0, Nohsbc=0, Nobancomer=0;

consultas="SELECT cve_periodo FROM conceptos_caja_vencimiento "
+"WHERE (CONVERT(VARCHAR(10),fecha_vencimiento,103) BETWEEN (SELECT CONVERT(VARCHAR(10),fecha_entrega_ficha,103) "
+"FROM katalogo_zertificazion_ziut WHERE (cve_pago="+cve_concepto+")) AND "
+"(SELECT CONVERT(VARCHAR(10),DATEADD(day,2,fecha_entrega_ficha),103) FROM katalogo_zertificazion_ziut WHERE (cve_pago="+cve_concepto+"))) AND (cve_pago="+cve_concepto+")";

rs=SMBD.SQLBD(consultas);

while(rs.next())
{
	cve_periodo=rs.getInt(1);
}
SMBD.desconectarBD();


ca.cve_concepto= cve_concepto;
ca.cve_periodo=cve_periodo;
ca.cve_persona=cve_persona;

referencias = ca.referencia(cve_persona, cve_concepto, cve_periodo);
//out.println(referencias);

consultas = "SELECT curp FROM personas WHERE (cve_persona = "+cve_persona+")";
rs = SMBD.SQLBD(consultas);
curp = "";
while (rs.next())
{
	curp = rs.getString(1);
}
SMBD.desconectarBD();


File reportFile = new File(application.getRealPath("/jsp/ziut/zertificaziones/"+nom_archivo));

parameters.put("logotipo","http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/imagenes/logoweb.jpg");
parameters.put("logotipo_ciut","http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/imagenes/logo_ciut.jpg");
parameters.put("logo_java","http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/imagenes/java.jpg");
parameters.put("banorte","http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/imagenes/banorte.jpg");
parameters.put("hsbc","http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/imagenes/hsbc.jpg");
parameters.put("bancomer","http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/imagenes/bancomer.jpg");
/*parameters.put("logotipo","http://localhost:8080"+request.getContextPath()+"/imagenes/logoweb.jpg");
parameters.put("logotipo_ciut","http://localhost:8080"+request.getContextPath()+"/imagenes/logo_ciut.jpg");
parameters.put("logo_java","http://localhost:8080"+request.getContextPath()+"/imagenes/java.jpg");
parameters.put("banorte","http://localhost:8080"+request.getContextPath()+"/imagenes/banorte.jpg");
parameters.put("hsbc","http://localhost:8080"+request.getContextPath()+"/imagenes/hsbc.jpg");
parameters.put("bancomer","http://localhost:8080"+request.getContextPath()+"/imagenes/bancomer.jpg");*/
	
		
fecha_actual=SMBD.fecha_actual();

consultas ="SELECT  TOP (1) conceptos_caja_vencimiento.fecha_vencimiento "
	+"FROM  conceptos_caja_vencimiento INNER JOIN "
	+"cat_conceptos_caja ON conceptos_caja_vencimiento.cve_pago = cat_conceptos_caja.cve_pago "
	+"WHERE (conceptos_caja_vencimiento.cve_pago ="+cve_concepto+") AND "
	+"(conceptos_caja_vencimiento.cve_periodo ="+cve_periodo+") AND ( GETDATE() < conceptos_caja_vencimiento.fecha_vencimiento) "
	+"ORDER BY conceptos_caja_vencimiento.fecha_vencimiento";
rs = SMBD.SQLBD(consultas);
while (rs.next())
{
	fecha_vencimiento = rs.getString(1);
	if (fecha_vencimiento==null) 
		{	
			fecha_vencimiento= " "; 
		}
		else
		{			
			fecha_vencimiento = fecha_vencimiento.substring(8,10)+"/" 
			+""+fecha_vencimiento.substring(5,7)+"/" 
			+""+fecha_vencimiento.substring(0,4);
		}
}
SMBD.desconectarBD();

parameters.put("fecha_actual",fecha_actual);
parameters.put("referencia",referencias);	
parameters.put("cve_persona",String.valueOf(cve_persona));
parameters.put("leyenda_caducidad",fecha_vencimiento);
parameters.put("curp", curp);


consultas = "SELECT codigo, descripcion "
	+"FROM  cat_conceptos_caja "
	+"WHERE (cve_pago = "+cve_concepto+")";
rs = SMBD.SQLBD(consultas);
while (rs.next())
{
	descripcion = rs.getString(1)+" / "+rs.getString(2);
}
SMBD.desconectarBD();

parameters.put("descripcion",descripcion);

		
consultas = "SELECT apellido_pat, apellido_mat, nombre "
		+"FROM personas "
		+"WHERE (cve_persona="+cve_persona+") ";
rs = SMBD.SQLBD(consultas);
while (rs.next())
{
	nombre = rs.getString(1)+" "+rs.getString(2)+" "+rs.getString(3);
}
SMBD.desconectarBD();

parameters.put("nombre",nombre);

consultas ="SELECT nombre, con.monto "
		   +"FROM katalogo_zertificazion_ziut kz "
		   +"INNER JOIN cat_conceptos_caja con ON con.cve_pago=kz.cve_pago "
		   +"WHERE (cve_certificacion="+cve_certificacion+")";
rs = SMBD.SQLBD(consultas);
while (rs.next())
{
	parameters.put("certificacion",rs.getString(1));
	monto=rs.getDouble(2);
}
SMBD.desconectarBD();

consultas="";

parameters.put("avizo_gral", aviso);

Nobanorte = 27317;
Nohsbc = 1622;
Nobancomer = 1344633;
parameters.put("banorteNo",String.valueOf(Nobanorte));
parameters.put("hsbcNo",String.valueOf(Nohsbc));
parameters.put("bancomerNo",String.valueOf(Nobancomer));

parameters.put("monto",monto+"");

total=(int)monto;
parameters.put("importe",d.convertirLetras(total).toUpperCase());

byte[] bytes =
	JasperRunManager.runReportToPdf(
		reportFile.getPath(),
		parameters,
		SMBD.getConnection()
		);
response.setContentType("application/pdf");
response.setContentLength(bytes.length);
ServletOutputStream ouputStream = response.getOutputStream();
ouputStream.write(bytes, 0, bytes.length);
ouputStream.flush();
ouputStream.close();
}
%>
