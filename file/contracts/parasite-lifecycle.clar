import pygame
import random
import json
from dataclasses import dataclass
from typing import List, Tuple, Dict

# Initialize Pygame
pygame.init()

# Game Constants
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
FPS = 60
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
BLUE = (0, 0, 255)
GREEN = (0, 255, 0)
RED = (255, 0, 0)

@dataclass
class ParasiteStage:
    name: str
    description: str
    duration: int
    required_conditions: List[str]
    next_stages: List[str]
    points: int

class ParasiteLifecycle:
    def __init__(self):
        # Example: Plasmodium (Malaria parasite) lifecycle
        self.stages = {
            "sporozoite": ParasiteStage(
                name="Sporozoite",
                description="Infectious form injected by mosquito",
                duration=48,
                required_conditions=["mosquito_bite"],
                next_stages=["liver_stage"],
                points=10
            ),
            "liver_stage": ParasiteStage(
                name="Liver Stage",
                description="Parasite develops in liver cells",
                duration=168,
                required_conditions=["healthy_liver"],
                next_stages=["merozoite"],
                points=20
            ),
            "merozoite": ParasiteStage(
                name="Merozoite",
                description="Blood-stage parasite",
                duration=72,
                required_conditions=["blood_cells"],
                next_stages=["gametocyte"],
                points=30
            ),
            "gametocyte": ParasiteStage(
                name="Gametocyte",
                description="Sexual stage picked up by mosquitoes",
                duration=96,
                required_conditions=["mosquito_bite"],
                next_stages=["sporozoite"],
                points=40
            )
        }
        self.current_stage = "sporozoite"
        self.score = 0
        self.time_in_stage = 0

class GameState:
    def __init__(self):
        self.screen = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
        pygame.display.set_caption("Parasite Life Cycle Educational Game")
        self.clock = pygame.time.Clock()
        self.parasite = ParasiteLifecycle()
        self.running = True
        self.font = pygame.font.Font(None, 36)
        
        # Player wallet for blockchain rewards
        self.player_wallet = {
            "address": None,
            "rewards": 0
        }

    def handle_events(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                self.handle_click(pygame.mouse.get_pos())

    def handle_click(self, pos):
        # Check if click is on any interactive elements
        current_stage = self.parasite.stages[self.parasite.current_stage]
        if self.parasite.time_in_stage >= current_stage.duration:
            for condition in current_stage.required_conditions:
                # Simulate meeting conditions through clicks
                self.parasite.score += current_stage.points
                self.advance_stage()
                break

    def advance_stage(self):
        current_stage = self.parasite.stages[self.parasite.current_stage]
        if current_stage.next_stages:
            self.parasite.current_stage = current_stage.next_stages[0]
            self.parasite.time_in_stage = 0
            self.award_blockchain_rewards(current_stage.points)

    def award_blockchain_rewards(self, points):
        """
        Placeholder for blockchain rewards integration
        To be implemented in next iteration with actual blockchain integration
        """
        self.player_wallet["rewards"] += points

    def update(self):
        self.parasite.time_in_stage += 1

    def draw(self):
        self.screen.fill(WHITE)
        
        # Draw current stage information
        current_stage = self.parasite.stages[self.parasite.current_stage]
        stage_text = self.font.render(f"Current Stage: {current_stage.name}", True, BLACK)
        desc_text = self.font.render(current_stage.description, True, BLACK)
        score_text = self.font.render(f"Score: {self.parasite.score}", True, BLUE)
        rewards_text = self.font.render(f"Rewards: {self.player_wallet['rewards']}", True, GREEN)
        
        self.screen.blit(stage_text, (20, 20))
        self.screen.blit(desc_text, (20, 60))
        self.screen.blit(score_text, (20, 100))
        self.screen.blit(rewards_text, (20, 140))
        
        pygame.display.flip()

    def run(self):
        while self.running:
            self.handle_events()
            self.update()
            self.draw()
            self.clock.tick(FPS)

def main():
    game = GameState()
    game.run()
    pygame.quit()

if __name__ == "__main__":
    main()