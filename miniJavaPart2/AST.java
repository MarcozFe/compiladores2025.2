import java.util.*;

public class AST {
    
    // Classe base para todos os nós
    public static abstract class Node {
        public abstract void print(String indent);
    }

    // Nó Raiz do Programa
    public static class Program extends Node {
        String id;
        List<Node> decls;

        public Program(String id, List<Node> decls) {
            this.id = id;
            this.decls = decls;
        }

        public void print(String indent) {
            System.out.println(indent + "Program: " + id);
            for (Node n : decls) {
                if (n != null) n.print(indent + "  ");
            }
        }
    }

    // Nó para Declarações de Classe
    public static class ClassDecl extends Node {
        String id;
        String parent;
        List<Node> body;

        public ClassDecl(String id, String parent, List<Node> body) {
            this.id = id;
            this.parent = parent;
            this.body = body;
        }

        public void print(String indent) {
            System.out.println(indent + "Class: " + id + (parent != null ? " extends " + parent : ""));
            for (Node n : body) if(n!=null) n.print(indent + "  ");
        }
    }

    // Nó para Declaração de Variável
    public static class VarDecl extends Node {
        String type;
        String id;
        Node expr; // Pode ser null se não tiver atribuição

        public VarDecl(String type, String id, Node expr) {
            this.type = type;
            this.id = id;
            this.expr = expr;
        }

        public void print(String indent) {
            System.out.println(indent + "Var: " + type + " " + id);
            if (expr != null) {
                System.out.println(indent + "  = ");
                expr.print(indent + "    ");
            }
        }
    }

    // Nó para Métodos
    public static class MethodDecl extends Node {
        String type;
        String id;
        List<Node> params;
        List<Node> stmts;

        public MethodDecl(String type, String id, List<Node> params, List<Node> stmts) {
            this.type = type;
            this.id = id;
            this.params = params;
            this.stmts = stmts;
        }

        public void print(String indent) {
            System.out.println(indent + "Method: " + type + " " + id);
            // Params (Opcional imprimir aqui)
            if (!params.isEmpty()) {
                System.out.println(indent + "  Params:");
                for (Node p : params) p.print(indent + "    ");
            }
            System.out.println(indent + "  Body:");
            for (Node s : stmts) if(s!=null) s.print(indent + "    ");
        }
    }

    // --- COMANDOS (STATEMENTS) ---

    public static class IfStmt extends Node {
        Node cond;
        Node thenStmt;
        Node elseStmt;

        public IfStmt(Node cond, Node thenStmt, Node elseStmt) {
            this.cond = cond;
            this.thenStmt = thenStmt;
            this.elseStmt = elseStmt;
        }

        public void print(String indent) {
            System.out.println(indent + "If");
            cond.print(indent + "  ");
            System.out.println(indent + "Then:");
            if(thenStmt!=null) thenStmt.print(indent + "  ");
            if (elseStmt != null) {
                System.out.println(indent + "Else:");
                elseStmt.print(indent + "  ");
            }
        }
    }

    public static class WhileStmt extends Node {
        Node cond;
        Node body;

        public WhileStmt(Node cond, Node body) {
            this.cond = cond;
            this.body = body;
        }

        public void print(String indent) {
            System.out.println(indent + "While");
            cond.print(indent + "  ");
            System.out.println(indent + "Do:");
            if(body!=null) body.print(indent + "  ");
        }
    }

    public static class AssignStmt extends Node {
        String id;
        Node expr;

        public AssignStmt(String id, Node expr) {
            this.id = id;
            this.expr = expr;
        }

        public void print(String indent) {
            System.out.println(indent + "Assign: " + id);
            expr.print(indent + "  ");
        }
    }
    
    public static class PrintStmt extends Node {
        Node expr;
        public PrintStmt(Node expr) { this.expr = expr; }
        public void print(String indent) {
            System.out.println(indent + "Print");
            expr.print(indent + "  ");
        }
    }
    
    public static class BlockStmt extends Node {
        List<Node> stmts;
        public BlockStmt(List<Node> stmts) { this.stmts = stmts; }
        public void print(String indent) {
            System.out.println(indent + "Block {");
            for(Node s : stmts) if(s!=null) s.print(indent+"  ");
            System.out.println(indent + "}");
        }
    }

    // --- EXPRESSÕES ---

    public static class BinOp extends Node {
        Node left;
        String op;
        Node right;

        public BinOp(Node left, String op, Node right) {
            this.left = left;
            this.op = op;
            this.right = right;
        }

        public void print(String indent) {
            System.out.println(indent + "BinOp: " + op);
            left.print(indent + "  ");
            right.print(indent + "  ");
        }
    }
    
    // CORREÇÃO AQUI: Verificação de null no expr
    public static class UnaryOp extends Node {
        String op;
        Node expr;
        public UnaryOp(String op, Node expr) { this.op = op; this.expr = expr; }
        public void print(String indent) {
            System.out.println(indent + "Unary: " + op);
            if (expr != null) { 
                expr.print(indent + "  ");
            }
        }
    }

    public static class Literal extends Node {
        String type;
        Object value;

        public Literal(String type, Object value) {
            this.type = type;
            this.value = value;
        }

        public void print(String indent) {
            System.out.println(indent + "Lit(" + type + "): " + value);
        }
    }
    
    public static class IdExpr extends Node {
        String name;
        public IdExpr(String name) { this.name = name; }
        public void print(String indent) { System.out.println(indent + "ID: " + name); }
    }
}