@RestController
public class GreetController {

    @PostMapping("/greet")
    public Map<String, String> greet(@RequestBody Map<String, String> payload) {
        String fullName = payload.get("firstName") + " " + payload.get("lastName");
        return Map.of("greeting", "Hello, " + fullName + "!");
    }
}